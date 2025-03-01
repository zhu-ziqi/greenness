function [stats, b, fig, linearModel] = timeSeriesPlotwithBreakYear(timeSeriesData, yearData, breakyear, options)
%  TIMESERIESPLOTWITHBREAKYEAR Plot timeseries data with a break year
%
% Inputs:
%   - timeSeriesData: A column vector of time series data.
%   - yearData: A column vector of corresponding years for the time series data.
%   - breakyear: The break year for the time series data (used for linear regression).
%   - options: A struct containing optional parameters for customization.
%       - pointColor: Color of the data points (default: orange).
%       - lineColor: Color of the connecting line (default: black).
%       - fitlineColor: Color of the fitted regression line (default: red).
%       - fitlinewidth: Width of the fitted regression line (default: 1).
%       - markersize: Size of the data points (default: 20).
%       - StatisDisp: Display statistics option ('on' or 'off', default: 'on').
%       - StatisDispItem: Statistics items to display (default: 'slope').
%       - LogScale: Use log scale for the y-axis ('on' or 'off', default: 'off').
%       - StatisLocation: Location to display statistics (default: 'northwest').
%
% Outputs:
%   - stats: Statistics of the linear regression model (e.g., R^2 value).
%   - b: Coefficients of the linear regression model.
%   - fig: Figure handle for the plot.
%
% Example usage:
%   % Generate sample data
%   yearData = (1990:2020)';
%   timeSeriesData = randn(length(yearData), 1);
%   breakyear = 2005;
%   % Plot time series data with break year and display statistics
%   options = struct('StatisDisp', 'on', 'StatisDispItem', 'r2+rmse', 'StatisLocation', 'northeast');
%   [stats, b, fig] = timeSeriesPlotwithBreakYear(timeSeriesData, yearData, breakyear, options);
arguments
    % Input arguments
    timeSeriesData double    % Time series data
    yearData double          % Year data
    breakyear double         % Break year
    % Default options
    options.pointColor = [7 7 7]./255; % Orange color [0.9290 0.6940 0.125]
    options.lineColor = [7 7 7]./255;
    options.lineStyle = '-';
    options.fitlineColor = [255 59 59]./255; % Red color
    options.linewidth = 0.6;
    options.fitlinewidth = 1;
    options.fitlinestyle = '--';
    options.markersize = 20;
    options.StatisDisp (1,:) char {mustBeMember(options.StatisDisp, {'on', 'off'})} = 'on'; % Display statistics
    options.StatisDispItem (1,:) char {mustBeMember(options.StatisDispItem, {'r', 'r2', 'rmse', 'equ', ...
        'r2+rmse', 'r2+rmse+equ', 'r2+rmse+num', 'r2+rmse+equ+num', 'slope'})} = 'slope'; % Statistics to display
    options.LogScale (1,:) char {mustBeMember(options.LogScale, {'on', 'off'})} = 'off'; % Log scale
    options.StatisLocation (1,:) char {mustBeMember(options.StatisLocation, {'northwest','northeast','southwest','southeast'})} = 'northwest'; % Location for displaying statistics
    options.logicScatter (1,:) char {mustBeMember(options.logicScatter, {'true', 'false'})} = 'true';
    options.logicLine (1,:) char {mustBeMember(options.logicLine, {'true', 'false'})} = 'true';
    options.logicRegLine (1,:) char {mustBeMember(options.logicRegLine, {'true', 'false'})} = 'true';
    options.logicConfidence (1,:) char {mustBeMember(options.logicConfidence, {'true', 'false'})} = 'false';
end
% Extract options for customization
pointColor = options.pointColor;
lineColor = options.lineColor;
fitlineColor = options.fitlineColor;
fitlinewidth = options.fitlinewidth;
marker_size = options.markersize;
% Plot time series data
yearData = yearData(:);
cliTimeSeries = timeSeriesData(:);
% Compute statistics
X = [ones(length(yearData),1), yearData(:) - yearData(1)];
y_value = cliTimeSeries(:);
[b,~,~,~,stats]=regress(y_value,X);
linearModel = fitlm(yearData(:) - yearData(1), y_value,"linear");
hold on;
if(strcmpi(options.logicScatter, 'true'))
    plot(yearData,cliTimeSeries,'.','MarkerSize',marker_size,"Color",pointColor); % Scatter plot
end
if(strcmpi(options.logicLine, 'true'))
    fig = plot(yearData,cliTimeSeries,options.lineStyle,"Color",lineColor,"LineWidth",options.linewidth); % Line plot
end
% Smooth the data
% yy1 = smooth(cliTimeSeries,5);
% Fit linear model
if(strcmpi(options.logicRegLine, 'true'))
    if(yearData(1) < breakyear)
        % When break year exists
        [p,~] = polyfit(yearData(yearData<breakyear),cliTimeSeries(yearData<breakyear),1);
        f=polyval(p,yearData(yearData<breakyear));
        plot(yearData(yearData<breakyear),f,'LineStyle',options.fitlinestyle,"LineWidth",fitlinewidth,"Color",fitlineColor); % Line fitting before break year
        [p,~] = polyfit(yearData(yearData>=breakyear),cliTimeSeries(yearData>=breakyear),1);
        f=polyval(p,yearData(yearData>=breakyear));
        plot(yearData(yearData>=breakyear),f,'LineStyle',options.fitlinestyle,"LineWidth",fitlinewidth,"Color",fitlineColor); % Line fitting after break year
    else
        % When break year does not exist
        [p,S] = polyfit(yearData,cliTimeSeries,1);
        % Evaluate the first-degree polynomial fit in p at the points in x.
        % Specify the error estimation structure as the third input so that
        % polyval calculates an estimate of the standard error. The
        % standard error estimate is returned in delta.
        [y_fit,delta] = polyval(p, yearData, S);
        plot(yearData,y_fit,'LineStyle',options.fitlinestyle,"LineWidth",fitlinewidth,"Color",fitlineColor); % Line fitting for entire data
        if(strcmpi(options.logicConfidence, 'true'))
            plot(yearData,y_fit+2*delta,'LineStyle',options.fitlinestyle,"LineWidth",fitlinewidth,"Color",fitlineColor);
            plot(yearData,y_fit-2*delta,'LineStyle',options.fitlinestyle,"LineWidth",fitlinewidth,"Color",fitlineColor);
            % title('Linear Fit of Data with 95% Prediction Interval')
        end
    end
end
% Display statistics if enabled
if(string(options.StatisDisp) == "on")
    R2 = stats(1);
    RMSE = sqrt(stats(2));
    switch options.StatisDispItem
        case 'equ'
            str=str_equation_disp;
        case 'r'
            r = corr(y_value,cliTimeSeries);
            str=['r = ',sprintf('%.2f',r)];
        case 'r2'
            str=['r^2 = ',sprintf('%.2f',R2)];
        case 'rmse'
            str=['RMSE = ',sprintf('%.2f',RMSE)];
        case 'r2+rmse'
            str=['RMSE = ',sprintf('%.2f',RMSE),...
                ', r^2 = ',sprintf('%.2f',R2)];
        case 'r2+pvalue'
            str=[ 'R^2 = ',sprintf('%.3f',R2), newline, ...
                'P value = ',sprintf('%.3f',stats(3)),...
                ];
        case 'r2+rmse+num'
            str=[['RMSE = ',sprintf('%.2f',RMSE)], newline, ...
                'n = ',sprintf('%d',stats(4)),...
                ', R^2 = ',sprintf('%.2f',R2),  newline, ...
                ];
        case 'r2+rmse+equ'
            str=[str_equation_disp,' R^2 = ',sprintf('%.2f',R2), newline, ...
                ' RMSE = ',sprintf('%.2f',RMSE)];
        case 'r2+rmse+equ+num'
            str=[str_equation_disp, newline, ...
                'n = ',sprintf('%d',stats(4)),...
                ', R^2 = ',sprintf('%.2f',R2),  newline, ...
                ['RMSE = ',sprintf('%.2f',RMSE)]
                ];
        case 'slope'
            str=['slope = ', num2str(b(2),3)];
    end
    % Determine position to display statistics
    xl = xlim;
    yl = ylim;
    switch options.StatisLocation
        case 'northwest'
            x_position = (xl(2) - xl(1))*0.06 + xl(1);
            y_position = (yl(2) - yl(1))*0.9 + yl(1);
        case 'northeast'
            x_position = (xl(2) - xl(1))*0.60 + xl(1);
            y_position = (yl(2) - yl(1))*0.90 + yl(1);
        case 'southwest'
            x_position = (xl(2) - xl(1))*0.06 + xl(1);
            y_position = (yl(2) - yl(1))*0.1 + yl(1);
        case 'southeast'
            x_position = (xl(2) - xl(1))*0.60 + xl(1);
            y_position = (yl(2) - yl(1))*0.1 + yl(1);
        otherwise
            x_position = (xl(2) - xl(1))*0.06 + xl(1);
            y_position = (yl(2) - yl(1))*0.9 + yl(1);
    end
    % Display statistics
    FontSize = get(gca, 'FontSize');
    text(x_position, y_position, str, 'FontSize', FontSize, 'Color', options.pointColor)
end
end