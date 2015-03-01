function [ cost ] = rmse( h, r )
%RMSE Compute root-mean squared error

resid = h(:) - r(:);
cost = sqrt(mean(resid.^2));

end

