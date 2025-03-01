function [trend_coefficient, pvalue_matrix, meanValue] = cal_linear_trend(raster_input, detection_method, alpha)
% CAL_LINEAR_TREND Calculate linear trend pixel by pixel
% Inputs:
%   raster_input: time series matrix (m*n*l matrix)
%   detection_method: method for detecting significance ('Ftest' or 'MK')
%   alpha: significance level for hypothesis testing (default: 0.05)

% Check if detection_method and alpha are provided, set default values if not
if nargin < 2
    detection_method = 'Ftest';
end

if nargin < 3
    alpha = 0.05;
end

% Get dimensions of the input raster
[rows, columns, pages] = size(raster_input);

% Initialize output variables
meanValue = zeros(rows, columns);
trend_coefficient = zeros(rows, columns);
pvalue_matrix = zeros(rows, columns);

% Calculate trend and significance pixel by pixel
for m = 1:rows
    for n = 1:columns
        % Extract time series for the current pixel
        data_row = squeeze(raster_input(m, n, :));

        % Count non-zero and non-NaN values
        count = sum(abs(data_row) >= 1E-9, 'all');

        % Calculate trend if data is sufficient
        if count >= pages * 0.3
            % Exclude NaN and zero values
            valid_idx = ~isnan(data_row) & data_row ~= 0;
            y_value = data_row(valid_idx);
            years = find(valid_idx);

            % Calculate mean value
            meanValue(m, n) = mean(y_value, 'all', 'omitnan');

            % Detect significance
            switch detection_method
                case 'MK'
                    % Mann-Kendall test
                    %   Inputs:
                    %     datain = (N x 2) double
                    %     alpha = (scalar) double
                    %     wantplot is a flag
                    %             ~= 0 means create plot, otherwise do not plot
                    %
                    %   Outputs:
                    %     taub = Mann-Kendall coefficient adjusted for ties
                    %     tau = Mann-Kendall coefficient not adjusted for ties
                    %                n(n-1)/2
                    %     h = hypothesis test (h=1 : is significant)
                    %     sig = p value (two tailed)
                    %     Z = Z score
                    %     sigma = standard deviation
                    %     sen = sen's slope
                    %     plotofslope = data used to plot data and sen's slope
                    %     cilower = lower confidence interval for sen's slope
                    %     ciupper = upper confidence interval for sen's slope
                    testdata = cat(2, years(:), y_value);
                    [~, ~, ~, pvalue, ~, ~, ~, slope, ~, ~, ~, ~] = ktaub(testdata, alpha, false);
                    % [~, pValue] = MannKendall(y_value, alpha);
                otherwise
                    % F-test
                    % Perform linear regression
                    X = [ones(length(years), 1), years(:)];
                    [b,~,~,~,stats] = regress(y_value, X);
                    pvalue = stats(3);
                    slope = b(2);
            end

            % Store p-value
            trend_coefficient(m, n) = slope;
            pvalue_matrix(m, n) = pvalue;
        else
            % Insufficient data
            trend_coefficient(m, n) = nan;
            pvalue_matrix(m, n) = nan;
            meanValue(m, n) = nan;
        end
    end
end

end
