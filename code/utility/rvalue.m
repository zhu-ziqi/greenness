function [r,p]=rvalue(data,estimate)
% Function to calculate correlation  from a data vector or matrix
% and the corresponding estimates.
% Usage: r=rsquare(data,estimate)
% Note: data and estimates have to be of same size
% Example: r=rsquare(randn(100,100),randn(100,100));

% delete records with NaNs in both datasets first
data=data(:);
estimate=estimate(:);
I = ~isnan(data) & ~isnan(estimate); 
data = data(I); estimate = estimate(I);

% corr = corrcoef(data,estimate);
% r=corr(1,2);
data = reshape(data,[],1);
estimate = reshape(estimate,[],1);
[r,p]=corr(data,estimate);