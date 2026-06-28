function mdl = scatter_plot_data_comparison(X, Y, Options)
% SCATTER_PLOT_DATA_COMPARISON: Plot data comparison
%
%   SCATTER_PLOT_DATA_COMPARISON(X,Y) creates a scatterplot of X and Y at
%   the locations specified by the vectors X and Y (which must be the same
%   size).
%
%   SCATTER_PLOT_DATA_COMPARISONR(...,'RobustOpts','on') allows you to set
%   the linear regression as the robust linear regression. Default is
%   'off'.
%
%   SCATTER_PLOT_DATA_COMPARISON(...,'StatisDisp','on') allows you to
%   display the R2, Regression equation and other statistic numbers.
%   Default is 'on'.
%
%   SCATTER_PLOT_DATA_COMPARISON(...,'PlotDisp','off') sets the whether or
%   not dispaly scatter plot. The default is to show the data.

% Copyright 2022 The MathWorks, Inc.
% $Revision: Zhu Ziqi    $Date:  2022/06/22

arguments
    X double
    Y double
    
    Options.RobustOpts (1,:) char {mustBeMember(Options.RobustOpts, {'on', 'off'})} = 'off'
    Options.StatisDisp (1,:) char {mustBeMember(Options.StatisDisp, {'on', 'off'})} = 'on'
    Options.StatisDispItem (1,:) char {mustBeMember(Options.StatisDispItem, {'r', 'r2', 'rmse', 'equ', ...
        'r+equ', 'r2+equ', 'r2+rmse', 'r2+rmse+equ', 'r2+rmse+num', 'r2+rmse+equ+num'})} = 'r2+rmse+equ+num'
    Options.LogScale (1,:) char {mustBeMember(Options.LogScale, {'on', 'off'})} = 'off'
    Options.StatisLocation (1,:) char {mustBeMember(Options.StatisLocation, {'northwest','northeast','southwest','southeast'})} = 'northwest'
    Options.StatisCrossZero char {mustBeMember(Options.StatisCrossZero, {'on', 'off'})} = 'off'
    Options.PlotDisp (1,:) char {mustBeMember(Options.PlotDisp, {'on', 'off'})} = 'on'
    Options.PlotConf (1,:) char {mustBeMember(Options.PlotConf, {'on', 'off'})} = 'off'
    Options.PlotDensity (1,:) char {mustBeMember(Options.PlotDensity, {'on', 'off'})} = 'off'
    Options.PlotConfAlpha (1,:) double {mustBeMember(Options.PlotConfAlpha, [0.05, 0.10])} = 0.05
    Options.PrcClip (1,:) char {mustBeMember(Options.PrcClip, {'on', 'off'})} = 'off'

    Options.refline (1,:) char {mustBeMember(Options.refline, {'on', 'off'})} = 'on'
    
    Options.regline (1,:) char {mustBeMember(Options.regline, {'on', 'off'})} = 'on'
    Options.reglinestyle (1,:) char {mustBeMember(Options.reglinestyle, {'-', '--', ':'})} = '--'
    Options.RegLineColor double = [255,59,59]/255
    Options.FontSize double = nan

    Options.AxisEqual (1,:) char {mustBeMember(Options.AxisEqual, {'on', 'off'})} = 'off'
    Options.AxisLim double = 0
    Options.MarkerSize double = 20
    Options.MarkerColor double = [7,7,7]/255
end

%% 1. scatters
% axis(gca,'square')
X = X(:);
Y = Y(:);

% Clear data
I = ~isnan(X) & ~isnan(Y) & (abs(X) >= 1e-5 & abs(Y) >= 1e-5);

X = X(I);
Y = Y(I);

if strcmpi(Options.PrcClip, 'on')
    prc_threshold = 5;
    prc_lower_x = prctile(X, prc_threshold, "all");
    prc_lower_y = prctile(X, prc_threshold, "all");
    I = X >= prc_lower_x & Y >= prc_lower_y;

    X = X(I);
    Y = Y(I);
end

A = ones(length(X),1)*Options.MarkerSize;

if(string(Options.LogScale) == "on")
    set(gca, 'Yscale', 'log', 'Xscale', 'log')
end

if(strcmp(Options.PlotDisp, "on"))
    % plot(X, Y, 'ko', 'Marker','.', 'MarkerFaceColor','auto', 'MarkerSize',10);
    scatter(X(:),Y(:),A(:),'MarkerFaceColor',Options.MarkerColor,'MarkerEdgeColor',Options.MarkerColor,...
        'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5)
end

%% 2. density
if(strcmpi(Options.PlotDensity, "on"))
    str_density_method = 'heatmap';
    switch str_density_method
        case 'dscatter'
            % Options are 'surf' (3D),'mesh' (3D), 'image'(2D) 'scatter'
            % (2D) and 'contour' (2D). These create surf, mesh and contour
            % plots colored by density of the scatter data.
            plot_type = 'scatter';
            dscatter(X(:),Y(:),'marker','.','smoothing',5,'plottype',plot_type);
            grid on;
        case 'densityScatterChart'
            hold off; % error for hold on
            % You can also set properties after making the chart:
            dfunc = @(x,y) log(1./sqrt((x-mean(x)).^2 + (y-mean(x)).^2));
            % d=densityScatterChart(x, y, 'UseColor', true, 'UseAlpha', true, "DensityMethod", dfunc);
            d=densityScatterChart(X(:), Y(:), 'UseColor', true, 'UseAlpha', true);

            % Make a steeper density view
            % d.DensityExponent = 2;
            d.UseAlpha = "on";
            d.AlphaRange = [.3 .6];
            % d.CLim = [0 5];
            % colormap turbo

            % dscatter(X(:),Y(:),'plottype','contour')
            % dscatter(X(:),Y(:),'marker','.','plottype','scatter','smoothing',20,'logy',false) % 'filled',true,
            % dscatter(X(:),Y(:),'marker','.','msize',12,'filled',true,'plottype','scatter','smoothing',LAMBDA,'logy',false)
        case 'heatmap'
            heat_map_scatter(X(:),Y(:));
            grid on;
    end
    
    nums = 160;
    % colormap
    CT = cbrewer_hint('div', 'RdGy', nums); CT = CT(nums/8:(nums/8*7),:);
    CT = cbrewer_hint('div', 'Spectral', nums); CT = CT(nums/16:(nums/16*15),:);
    % CT = cbrewer('seq', "GnBu", nums, 'PCHIP'); CT = CT(1:(nums/8*7),:);
    
    CT = flipud(CT);
    % CT = flipud(cbrewer('div', 'Spectral', nums, 'PCHIP'));
    % CT = CT(nums/8:nums/8+7,:);
    colormap(CT);
end

hold on;

if(any(Options.AxisLim))
    ax = gca;
    ax.XLim = Options.AxisLim(1:2);
    ax.YLim = Options.AxisLim(3:4);
    xlim_range = ax.XLim;
    ylim_range = ax.YLim;
else
    xlim_range = xlim;
    ylim_range = ylim;
end

if(string(Options.AxisEqual) == "on")
    % ax = gca;
    % xl = xlim;
    % axis equal
    axis("equal")
end

% 1:1 line
if(strcmp(Options.refline, "on"))
    plot(xlim_range, xlim_range, [Options.reglinestyle], "Color", [0.6,0.6,0.6])
end

% Ls = lsline;
% set(Ls, 'Color', 'r')
% Ls.LineWidth = 1.0;
% Ls.LineStyle = '--';

box on;
dataTable = table(X,Y);
if(~strcmp(Options.StatisCrossZero, "on"))
    % Cross zeros or not
    str_equation = 'Y ~ X';
else
    str_equation = 'Y ~ X - 1';
end
if(strcmp(Options.RobustOpts, "on"))
    mdl = fitlm(dataTable, str_equation, "RobustOpts", Options.RobustOpts);
else
    mdl = fitlm(dataTable, str_equation);
end

% plot confidence intervals
[m,n]=size(X');                         %计算自变量矩阵行列数

% 回归
Xdata = [ones(size(X)), X];
% a matrix bint of 95% confidence intervals
[b,bint,E,Eint,Stats] = regress(Y,Xdata);
% Solid and dashed regression lines
% indicate statistically significant and non-significant trends at the 0.05 level, respectively.

xval = linspace(min(X)-0.05, max(X)+0.05, 100);
yhat = b(1)+b(2)*xval;

%计算自变量的离差平方和
% Sxx=sumsqr(x-mean(x));
Sxx=sum((X-mean(X)).^2);
x_sorted = sort(X);
% x_sorted = linspace(min(x)-(max(x)-min(x))/30, max(x)-(max(x)-min(x))/30,100); % Error！
x_sorted = x_sorted(:)'; % 变为行向量
y_sorted = b(1)+b(2)*x_sorted;
gamma=sqrt(finv(1-Options.PlotConfAlpha,m,n-m-1)*(1/n+(x_sorted-mean(x_sorted)).^2/Sxx)*Stats(4));

if(strcmpi(Options.PlotConf, "on"))
    %计算预测值置信尺度

    % ylow = bint(1,1)+bint(2,1)*xval;
    % yupp = bint(1,2)+bint(2,2)*xval;
    ylow = y_sorted-gamma;                         %计算预测值的下限
    yupp = y_sorted+gamma;

    % patch([xval fliplr(xval)], [ylow fliplr(yupp)], 'k', 'FaceColor', color_vector, 'EdgeColor','white')
    % X low : X high : Xlow Ylow:YHigh:Ylow (先从左到右，从上到下）
    patch([x_sorted fliplr(x_sorted)], [ylow fliplr(yupp)], 'k', 'FaceColor', Options.RegLineColor, 'EdgeColor','white')
    alpha(0.3)
end

if isnan(Options.FontSize)
    FontSize = get(gca, 'FontSize');
else
    FontSize = Options.FontSize;
end
set(gca, 'FontSize', FontSize)

%% 3. regression line
if(strcmp(Options.regline, "on"))
    if(~strcmp(Options.StatisCrossZero, "on"))
        % Cross zeros or not
        if(strcmpi(Options.PlotConf, "on"))
            xlim_plot = minmax(x_sorted);
        else
            xlim_plot(1) = max(xlim_range(1), (ylim_range(1) - mdl.Coefficients.Estimate(1))./mdl.Coefficients.Estimate(2), "omitnan");
            xlim_plot(2) = min(xlim_range(2), (ylim_range(2) - mdl.Coefficients.Estimate(1))./mdl.Coefficients.Estimate(2), "omitnan");
        end

        plot(xlim_plot, xlim_plot * mdl.Coefficients.Estimate(2) + mdl.Coefficients.Estimate(1), "Color", Options.RegLineColor, 'LineWidth', 1.0, 'LineStyle', '--');

        if(mdl.Coefficients.Estimate(1)>=0)
            str_equation_disp = ['Y = ',sprintf('%.2f',mdl.Coefficients.Estimate(2)),'X + ',sprintf('%.2f',mdl.Coefficients.Estimate(1))];
        else
            str_equation_disp = ['Y = ',sprintf('%.2f',mdl.Coefficients.Estimate(2)),'X - ',sprintf('%.2f',abs(mdl.Coefficients.Estimate(1)))];
        end
    else
        plot(xlim_range, xlim_range * mdl.Coefficients.Estimate(1), "Color", Options.RegLineColor, 'LineWidth', 1.0, 'LineStyle', '--');
        str_equation_disp = ['Y = ',sprintf('%.2f',mdl.Coefficients.Estimate(1)),'X'];
    end

    if(string(Options.StatisDisp) == "on")

        R2 = rsquare(Y,mdl.Fitted);
        RMSE = rmse(Y,mdl.Fitted);
        x_position_delta = 0.0;

        switch Options.StatisDispItem
            case 'equ'
                str=str_equation_disp;
                y_position_delta = 0.04;
            case 'r'
                r = corr(Y,mdl.Fitted);
                str=['\it{r}\rm = ',sprintf('%.2f',r)];
                x_position_delta = 0.10;
                y_position_delta = 0.04;
            case 'r+equ'
                r = corr(Y,mdl.Fitted);
                str=[str_equation_disp, ', r = ',sprintf('%.2f',r)];
                y_position_delta = 0.04;
            case 'r2'
                % str = 'R^2';
                % str=['$R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary),'$'];
                str=['R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary)];
                y_position_delta = 0.04;
            case 'r2+equ'
                str=[str_equation_disp, ', R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary)];
                y_position_delta = 0.04;
            case 'rmse'
                str=['RMSE = ',sprintf('%.2f',RMSE)];
                y_position_delta = 0.04;
            case 'r2+rmse'
                str=['RMSE = ',sprintf('%.2f',RMSE),...
                    ', R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary)];
                y_position_delta = 0.04;
            case 'r2+pvalue'
                str=[ 'R^2 = ',sprintf('%.3f',R2), newline, ...
                    'P value = ',sprintf('%.3f',mdl.Coefficients.pValue(2)),...
                    ];
                y_position_delta = 0.0;
            case 'r2+rmse+num'
                str=[['RMSE = ',sprintf('%.2f',RMSE)], newline, ...
                    'n = ',sprintf('%d',mdl.NumObservations),...
                    ', R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary),  newline, ...
                    ];
                y_position_delta = 0.0;
            case 'r2+rmse+equ'
                str=[str_equation_disp,', R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary), newline, ...
                     'RMSE = ',sprintf('%.2f',RMSE)];
                y_position_delta = 0.0;
            case 'r2+rmse+equ+num'
                str=[str_equation_disp, newline, ...
                    'n = ',sprintf('%d',mdl.NumObservations),...
                    ', R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary),  newline, ...
                    ['RMSE = ',sprintf('%.2f',RMSE)]
                    % ', R^2 = ',sprintf('%.3f',R2), newline, ...
                    % 'P value = ',sprintf('%.3f',mdl.Coefficients.pValue(2)),...
                    ... %',  Slope = ',sprintf('%.3f',mdl.Coefficients.Estimate(2)), ...
                    ];
                y_position_delta = 0.0;
        end


        if(any(Options.AxisLim))
            ax = gca;
            ax.XLim = Options.AxisLim(1:2);
            ax.YLim = Options.AxisLim(3:4);
        end

        xl = xlim;
        yl = ylim;
        switch Options.StatisLocation
            case 'northwest'
                x_position = (xl(2) - xl(1))*0.02 + xl(1);
                y_position = (yl(2) - yl(1))*(0.90 + y_position_delta) + yl(1);
            case 'northeast'
                x_position = (xl(2) - xl(1))*(0.60+x_position_delta) + xl(1);
                y_position = (yl(2) - yl(1))*(0.90 + y_position_delta) + yl(1);
            case 'southwest'
                x_position = (xl(2) - xl(1))*0.06 + xl(1);
                y_position = (yl(2) - yl(1))*(0.1 - y_position_delta) + yl(1);
            case 'southeast'
                x_position = (xl(2) - xl(1))*(0.60+x_position_delta) + xl(1);
                y_position = (yl(2) - yl(1))*(0.1 - y_position_delta) + yl(1);
            otherwise
                x_position = (xl(2) - xl(1))*0.06 + xl(1);
                y_position = (yl(2) - yl(1))*(0.90 + y_position_delta) + yl(1);
        end

        try
            text(x_position, y_position, str, 'FontSize', FontSize+1.0, 'Color', Options.MarkerColor)
            % text(x_position, y_position, ['\textbf{\textsf{Arial} }',str], 'FontSize', FontSize+1.0, 'Color', Options.MarkerColor, 'Interpreter', 'latex', 'String', str, 'FontName', 'Helvetica')
        catch
            text(x_position, y_position, str, 'FontSize', FontSize+1.0, 'Color', Options.MarkerColor)
        end
    end

end

hold off
end