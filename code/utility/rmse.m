function [r,nr,pr]=rmse(data, estimate, Weight)
% Function to calculate root mean square error from a data vector or matrix
% and the corresponding estimates.
% Usage: r=rmse(data,estimate)
% Note: data and estimates have to be of same size
% Example: r=rmse(randn(100,100),randn(100,100));

% E = rmse(F,A) returns the root mean squared error (RMSE) between the forecast (predicted) array F and the actual (observed) array A.
% E = rmse(___,Weights=W) specifies a weighting scheme W and returns the weighted RMSE.
arguments
    data double
    estimate double
    Weight double = nan
end

% delete records with NaNs in both datasets first
data=data(:);
estimate=estimate(:);

% clear data
I = ~isnan(data) & ~isnan(estimate) & ~isinf(data) & ~isinf(estimate); 
data = data(I); estimate = estimate(I);

if isnan(mean(Weight,"all","omitnan"))
    % without weight
    r = sqrt( sum((data(:)-estimate(:)).^2) / numel(data) );
else
    % with weight
    % For a forecast array F and actual array A made up of n scalar observations and weighting scheme W, the weighted root mean squared error is defined as
    r = sqrt( sum(Weight(:) .* ((data(:)-estimate(:)).^2),"all","omitnan") / sum(Weight(:),"all","omitnan") );
end

nr= r/range(data);

pr= r/ mean(data);