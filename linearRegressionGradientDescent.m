data = load('ex1data1.txt');
X = data(:, 1); y = data(:, 2);
m = length(y); % number of training examples

% Plot Data to check if required
plot(X,y,'rx','MarkerSize',1);
ylabel('Profit in $10,000s');
xlabel('Population of City in 10,000s');

X = [ones(m, 1), data(:,1)]; % Add a column of ones to x
theta = zeros(2, 1); % initialize fitting parameters

% Some gradient descent settings
iterations = 1500;
alpha = 0.01;
J_history = zeros(iterations, 1);

for iter = 1:iterations
    h = X*theta;
    z = h - y;
    a1 = X(:,1)' * z;
    a2 = X(:,2)' * z;
    theta(1) = theta(1) - alpha*a1/m;
    theta(2) = theta(2) - alpha*a2/m;
    % Save the cost J in every iteration
    z = z .^2;
    J = sum(z) / (2*m);
    J_history(iter) = J;
end


hold on;
plot(X(:,2), X*theta, '-')
legend('Training data', 'Linear regression')
hold off % don't overlay any more plots on this figure

fprintf('Visualizing J(theta_0, theta_1) ...\n')

% Grid over which we will calculate J
theta0_vals = linspace(-10, 10, 100);
theta1_vals = linspace(-1, 4, 100);

% initialize J_vals to a matrix of 0's
J_vals = zeros(length(theta0_vals), length(theta1_vals));

% Fill out J_vals
for i = 1:length(theta0_vals)
    for j = 1:length(theta1_vals)
	  t = [theta0_vals(i); theta1_vals(j)];
    h = X*t;
    z = h - y;
    z = z .^2;
    J = sum(z) / (2*m);
    J_vals(i,j) = J;
    end
end

% Because of the way meshgrids work in the surf command, we need to
% transpose J_vals before calling surf, or else the axes will be flipped
J_vals = J_vals';
% Surface plot
figure;
surf(theta0_vals, theta1_vals, J_vals)
xlabel('\theta_0'); ylabel('\theta_1');

% Contour plot
figure;
% Plot J_vals as 15 contours spaced logarithmically between 0.01 and 100
contour(theta0_vals, theta1_vals, J_vals, logspace(-2, 3, 20))
xlabel('\theta_0'); ylabel('\theta_1');
hold on;
plot(theta(1), theta(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
