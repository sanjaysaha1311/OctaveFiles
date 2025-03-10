function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

% fprintf('Size of theta: %d %d\n', size(theta));
% fprintf('Size of X: %d %d\n', size(X));
% fprintf('Size of lambda: %d %d\n', size(lambda));

h_theta = sigmoid(X*theta);

J = lambda / (2 * m) * sum(theta(2:end) .^ 2) + (-1 ./ m .* sum(y .* log(h_theta) + (1.-y) .* log(1 - h_theta )));

grad = (lambda ./ m .* (theta)) .+ (1 ./ m .* sum((h_theta .- y) .* X))';

grad(1) = grad(1) .- lambda ./ m .* (theta(1));

% fprintf('Size of grad: %d %d\n', size(grad));

% =============================================================

end
