function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% ============================== %
%%  FORWARD PROPAGATION STARTS  %%
% ============================== %
a1 = [ones(m, 1) X];
z2 = a1 * Theta1';
a2 = sigmoid(z2);

a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
a3 = sigmoid(z3);

h_theta = a3;

% Following loop computes Cost a.k.a. J
for k = 1 : num_labels
  y_k = y == k;
  h_theta_k = h_theta(:,k);
  J_k = 1 / m * sum( -y_k.*log(h_theta_k) - (1-y_k).*log(1-h_theta_k) );
  J = J + J_k;
end

% Following loop computes REGULARIZED Cost a.k.a. J
J = J + (lambda/(2*m) * (sum(sum(Theta1(:, 2:end).^2)) + sum(sum(Theta2(:, 2:end).^2))));

% ============================== %
%%    BACK PROPAGATION STARTS   %%
% ============================== %
for i = 1 : m
  
  % The following loop computes 'delta 3'
  for k = 1 : num_labels
    y_k = y(i) == k;
    d3(k) = a3(i, k) - y_k;
  end

  % The following line computes 'delta 2'
  d2 = (Theta2'*d3'.*sigmoidGradient([1, z2(i, :)])')(2:end);

  % Calculate Gradient (accumulation)
  Theta1_grad = Theta1_grad + d2 * a1(i, :);
  Theta2_grad = Theta2_grad + d3' * a2(i, :);
end

% Calculate Gradient (averaging)
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

% REGULARIZE the Gradients that are already calculated
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + (lambda/m).*Theta1(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + (lambda/m).*Theta2(:, 2:end);
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
