load movies.mat

% This command will load the following data into your workspace.
%
% 1) Metadata
%     
%     nUsers     # of users
%     nMovies    # of movies
%     userData   struct with info about users (you won't need this)
%     movieData  struct with info about movies (you won't need this)
%  
% 2) Training data (60K ratings). This consists of three vectors, 
%    each of length 60K:
%
%      train_user, train_movie, train_rating
%
%    The entries specify the ratings:
%   
%      train_user(k)    user index  of kth rating
%      train_movie(k)   movie index of kth rating
%      train_rating(k)  value (1-5) of kth rating
%
% 2) Validation data (20K ratings). Three vectors of length 20K:
%
%      valid_user, valid_movie, valid_rating
%   
%    Use this to evaluate your model and tune parameters.
%    
% 3) Test set (20K user-movie pairs without ratings):
%
%      test_user, test_movie
%
%    You will create predictions for these pairs and submit them for 
%    grading.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tunable parameters (you will add more)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nDims = 10;    % size of weight/feature vectors


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U  = randn(nUsers, nDims) *.01;   % User weights
V  = randn(nMovies, nDims)*.01;   % Movie features
a  = randn(nUsers,1) * .01;             % User biases (for extended model)
b  = randn(nMovies,1) * .01;            % Movie biases (for extended model)
mu = mean(train_rating);          % Overall mean
alpha = 0.002;
lambda_U = .09;
lambda_V = .06;
iter = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training / Validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: write code to train model and evaluate performance on validation set
train_rmse = zeros(iter, 1);
valid_rmse = zeros(iter, 1);
for m = 1:iter
    for n = 1:length(train_movie)
        i = train_user(n) ;
        j = train_movie(n);
        r = train_rating(n);
    
        h = mu + a(i) + b(j) + U(i,:) * V(j,:)'; % hypothesis
        
        resid = h-r;
        U(i,:) = U(i,:)-alpha*(resid.* V(j,:) + lambda_U.* U(i,:));
        V(j,:) = V(j,:)-alpha*(resid.* U(i,:) + lambda_V.* V(j,:));  
        a(i) = a(i) - alpha * resid;
        b(j) = b(j) - alpha * resid;
        mu = mu - alpha * resid;
    end
    
    train_predictions = predict(mu, train_user, train_movie, U, V, a, b);
    valid_predictions = predict(mu, valid_user, valid_movie, U, V, a, b);
    
    train_rmse(m) = rmse(train_predictions, train_rating);
    valid_rmse(m) = rmse(valid_predictions, valid_rating);
    
    fprintf('iteration %d, train rmse = %.4f, validation rmse = %.4f\n', m, train_rmse(m), valid_rmse(m));
end

%  predict() is a stub that predicts the overall mean for all user-movie
%  pairs. Update it to take more parameters and make real predictions.

plot(train_rmse, 'color', 'red');
hold on;
plot(valid_rmse, 'color', 'blue');
hold off;
title('Root Mean Squared Error vs iterations');
legend('training', 'validation');
xlabel('iterations');
ylabel('Root Mean Squared Error (RMSE)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make and save predictions for test set
%% GIVE PROFESSOR RMSE FOR VALIDATION SET%%

test_predictions = predict(mu, test_user, test_movie, U, V, a, b)';
save test_predictions.txt test_predictions -ascii
