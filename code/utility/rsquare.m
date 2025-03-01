function r2=rsquare(data,estimate)

% delete records with NaNs in both datasets first
data = data(:);
estimate= estimate(:);

I = ~isnan(data) & ~isnan(estimate) & ~isinf(data) & ~isinf(estimate); 
data = data(I); estimate = estimate(I);

if numel(data)>0
    r2 = corr(data,estimate) ^2;
else
    r2 =nan;
end
