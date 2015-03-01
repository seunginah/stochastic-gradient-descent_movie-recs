function [predictions] = predict(mu, user, movie, U, V, a, b)
%PREDICT Make predictions for user/movie pairs
%
% Inputs: 
%   model parameters
%   user               vector of users
%   movie              vector of movies
%
% Output:
%   predictions        vector of predictions
%


% This is a stub that predicts the mean rating for all user-movie pairs
% Replace with your code.

predictions = size(user,1);

for n=1:size(user,1)
    i = user(n) ;
    j = movie(n);
    
    predictions(n)= mu + a(i) + b(j) + U(i,:) * V(j,:)'; % hypothesis
end

end

