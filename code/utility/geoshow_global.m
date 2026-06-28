function geoshow_global(image_target, ref_disp, options)
%  GEOSHOW_GLOBAL Show the global map of the data
% GEOSHOW_GLOBAL displays a global image with coastlines.
%
% Inputs:
%   - image_target: 2D or 3D array representing the image data.
%   - ref_disp (optional): Geographic raster reference object defining the
%     spatial reference of the image. If not provided, a default reference
%     covering the entire globe is created.
%
% Example usage:
%   geoshow_global(image_data);
%   geoshow_global(image_data, ref_object);
% Convert image to double for display
arguments
    image_target double
    ref_disp = georasterref('RasterSize', size(image_target), ...
        'Latlim', [-90 90], 'Lonlim', [-180 180], ...
        'RasterInterpretation', 'cells', 'ColumnsStartFrom', 'north');
    options.lats double = [-60, 90]
    options.lons double = [-180, 180]
    options.pvalue_matrix double
    options.pvalue_thres double = 0.10
    options.plot_pvalue char {mustBeMember(options.plot_pvalue, {'true', 'false'})} = 'false';
    options.plot_histogram char {mustBeMember(options.plot_histogram, {'true', 'false'})} = 'false';
    options.map_projection char {mustBeMember(options.map_projection, {'eqdcylin','eckert4' 'default','utm'})} = 'default'
    options.plot_map_surface char {mustBeMember(options.plot_map_surface, {'true', 'false'})} = 'true';
    options.plot_pvalue_size = ref_disp.RasterSize / 6;
    options.logic_show_ticks char {mustBeMember(options.logic_show_ticks, {'true', 'false'})} = 'true';
    options.logic_show_xticks char {mustBeMember(options.logic_show_xticks, {'true', 'false'})} = 'true';
    options.logic_show_yticks char {mustBeMember(options.logic_show_yticks, {'true', 'false'})} = 'true';
    % DisplayType — Display type
    % 'point' | 'multipoint' | 'line' | 'polygon' | 'image' | 'surface' | 'mesh' | 'texturemap' | 'contour'
    options.plot_map_type char {mustBeMember(options.plot_map_type, {'image','surface','mesh','texturemap','contour','polygon','line','point','multipoint'})} = 'surface';
end
image_target = double(image_target);
% Plot the image on a map
% figure;
if strcmpi(options.plot_histogram, 'true')
    ax1 = axes('Color', 'none');
    ax2 = axes('Position',[0.186, 0.34, 0.26, 0.14]);
    axes(ax1);
end
if(~strcmpi(options.map_projection, 'default'))
    ax = worldmap(options.lats, options.lons); % worldmap('antarctica')
    box on
    ax.LineWidth = 1.0;
    % default Plate Carrée projection
    setm(gca,'mapprojection',options.map_projection); % 等距离，圆柱投影
end
if strcmpi(options.plot_map_surface, 'true')
    % geoshow(image_target, ref_disp, 'DisplayType', 'surface');
    geoshow(image_target, ref_disp, 'DisplayType', options.plot_map_type);
else
    % geoshow(image_target, ref_disp);
end
% Load coastlines data and plot
load("coastlines.mat", "coastlat", "coastlon");
geoshow(coastlat, coastlon, 'Color', [0.3 0.3 0.3]);
% Set colormap
% nums = 60; CT = cbrewer('div', 'Spectral', nums); colormap(CT(nums/3:end,:));
if strcmpi(options.plot_map_type, 'texturemap')
    % nums = 1200; CT = slanCM(56, nums); colormap(cat(1, [1.0,1.0,1.0], CT(nums/6:(end-1),:)));
    nums = 1200; CT = cbrewer_hint('div', 'Spectral', nums); colormap(CT(nums/3:end,:));
else
    % nums = 60; CT = slanCM(56, nums); colormap(CT(nums/6:(end),:));
    nums = 60; CT = cbrewer_hint('div', 'Spectral', nums); colormap(CT(nums/3:end,:));
end
% Set limits and tick labels
xlim(options.lons);
ylim(options.lats);
xticks(-150:50:150);
yticks(-30:30:90);
% Tick labels
if strcmpi(options.logic_show_ticks, 'true')
    if strcmpi(options.logic_show_xticks, 'true') && strcmpi(options.logic_show_yticks, 'true')
        xticklabels({'-150°', '-100°', '-50°','0°', '50°', '100°', '150°'});
        yticklabels({'-30°', '0', '30°', '60°'});
    elseif strcmpi(options.logic_show_xticks, 'true') && strcmpi(options.logic_show_yticks, 'false')
        xticklabels({'-150°', '-100°', '-50°','0°', '50°', '100°', '150°'});
        yticklabels({'', '', '', ''});
    elseif strcmpi(options.logic_show_yticks, 'true') && strcmpi(options.logic_show_xticks, 'false')
        yticklabels({'-30°', '0°', '30°', '60°'});
        xticklabels({'', '', '','', '', '', ''});
    end
elseif strcmpi(options.logic_show_ticks, 'false')
    xticklabels({'', '', '','', '', '', ''});
    yticklabels({'', '', '', ''});
end
box on;
%% Add histogram subplot
if strcmpi(options.plot_histogram, 'true')
    data_show = image_target(image_target > min(image_target,[],"all","omitnan"));
    axes(ax2);
    % set(gca, 'FontSize', 10)
    hold on
    histogram(data_show,12,'Normalization','pdf','Visible','on','FaceColor',[0.6, 0.6, 0.6]);
    h = histfit(data_show,16,"kernel");
    % area(cat(2, prctile(data_show,35), prctile(data_show,62)), [60,60], 'EdgeColor',[.3, .3, .3],'FaceColor',[7,7,7]/255,'FaceAlpha',0.3)
    plot(repmat(median(data_show,"all"),[1,2]), ylim, 'r--', 'LineWidth',1.2)
    % xlim([0,2])
    h(1).FaceColor = [.8, .8, .8];
    h(1).EdgeColor = [.3, .3, .3];
    h(2).Color = [.2 .2 .2];
    box on
    % xlabel('Pixel Value');
    % ylabel('Frequency');
    % axes(ax1)
end
%% show the trend with pvalue
if strcmpi(options.plot_pvalue, 'true')
    % get the lattitude and longitude
    lat_bin = ref_disp.CellExtentInLatitude;
    lon_bin = ref_disp.CellExtentInLongitude;
    lat_lim = ref_disp.LatitudeLimits;
    lon_lim = ref_disp.LongitudeLimits;
    lat_matrix_roi = single(repmat(((lat_lim(1)+lat_bin/2):lat_bin:lat_lim(2))',[1,ref_disp.RasterSize(2)]));
    lat_matrix_roi = flipud(lat_matrix_roi);
    lon_matrix_roi = single(repmat((lon_lim(1)+lon_bin/2):lon_bin:lon_lim(2),[ref_disp.RasterSize(1),1]));
    % size_target = size(image_target, [1,2]);
    % size_target = [size_target(1), size_target(2)]/5;
    size_target = options.plot_pvalue_size;
    % resample to coarse resolution
    lat_matrix_roi_disp = imageresample(lat_matrix_roi, ...
            "rows_target", size_target(1), "cols_target", size_target(2), ...
            "function","imaggregation","method_resample","mean");
    lon_matrix_roi_disp = imageresample(lon_matrix_roi, ...
            "rows_target", size_target(1), "cols_target", size_target(2), ...
            "function","imaggregation","method_resample","mean");
    pvalue_disp = imageresample(options.pvalue_matrix, ...
            "rows_target", size_target(1), "cols_target", size_target(2), ...
            "function","imaggregation","method_resample","median");
    % show the point
    p_matrix_idx = pvalue_disp>0 & pvalue_disp<options.pvalue_thres;
    lat_matrix_vector = lat_matrix_roi_disp(p_matrix_idx);
    lon_matrix_vector = lon_matrix_roi_disp(p_matrix_idx);
    hold on;
    geoshow(lat_matrix_vector, lon_matrix_vector, 'Marker', '.', ...
        "MarkerSize", 4, "Color", [0.1,0.1,0.1], "LineStyle","none");
    hold off
end
% Add colorbar (optional)
% cb = colorbar(ax);
% cb.Position = cb.Position + [0.03 -0.06 -0.02 0.12];
end