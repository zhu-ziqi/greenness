function [seasonality, timing, timing_cos, Vx, Vy] = TS(V, options)
% TS Summary: Calculate seasonality and timing
% Detailed explanation 
% ==================================================
% Input Parameter: Vector(12x1) or Matrix(n*m*12)
% Output Parameter:
% 1. seasonal concentration (which is inversely related to season length)
% 2. phase (expressing the timing of the season)
% ==================================================
arguments
    % Data
    V double
    % Time Step
    options.timestep double = 30
    % Plot the spatial distribution
    options.plot_timing char {mustBeMember(options.plot_timing, {'true', 'false'})} = 'false';
    options.plot_seasonality char {mustBeMember(options.plot_seasonality, {'true', 'false'})} = 'false';
end

% Shape of V
[x,y,z] = size(V);
if(options.timestep == 30)
    % The start day of each month
    day_start = [0,31,59,90,120,151,181,212,243,273,304,334];

    % The middle day of each month
    % midday = c()
    midday(1:11) = (day_start(1:11) + day_start(2:12)-1)/2;
    midday(12) = (day_start(12)+365)/2;
elseif(options.timestep == 1)
    if(x > 1 && y> 1)
        % The raster data
        midday = 1:1:z;
    else
        % The vector data
        midday = 1:1:max([x,y,z]);
    end
else
    % The start day of each month
    day_start = 1:options.timestep:365;
    day_num = numel(day_start);
    % The middle day of each month
    % midday = c()
    midday(1:(day_num-1)) = (day_start(1:(day_num-1)) + day_start(2:day_num)-1)/2;
end

% From middle days to angles
angle_mid = 2*pi*midday/365; % angle_mid: 1x12 vector

% Reshape data 
if(z == 1)
    V = reshape(V, [1 1 max([x,y,z])]);
    angle_mid = reshape(angle_mid, [1 1 max([x,y,z])]);
end

try
    % Vector decomposition
    mVx = (V.*cos(angle_mid));
    mVy = (V.*sin(angle_mid));
catch
    % Raster decomposition
    angle_mid_vector(1,1,:) = angle_mid;
    angle_mid_matrix = repmat(angle_mid_vector, [x, y, 1]);
    mVx = (V.*cos(angle_mid_matrix));
    mVy = (V.*sin(angle_mid_matrix));
end

% Sum the X and Y component
Vx = sum(mVx,3);
Vy = sum(mVy,3);
totalV = sum(V,3);

% Direction of vector
timing = atan2(Vy,Vx); % Phase Vy/Vx = sin(V)/cos(V)

% get similar results for (12, 1, 2)
timing_cos = Vx ./ sqrt(Vx.*Vx + Vy.*Vy);

 % convert from -pi to pi => 0 to 2pi
timing(((Vx~=0)&(timing<0))) = 2*pi+timing(((Vx~=0)&(timing<0))); 
timing(timing <= 1e-6) = nan;

% if(options.timestep == 30)
%     timing = timing./pi.*6;  % constrain timing at the range of 0 to 12 (Growing season subtract 3 -3~9)
%     % timing = timing + 1; % from 1 to 13
% else
%     timing = timing./pi.*6; 
%     % timing = timing./(2*pi)*365; % convert to days
% end
timing = timing./pi.*6;

% If the variable is evenly spread over all months (0 < seasonality < 1)
seasonality = sqrt(Vx.^2+Vy.^2)./totalV;

if(strcmpi(options.plot_timing, 'false') && strcmpi(options.plot_seasonality, 'true'))
    % plot seasonality
    geoshow_global(seasonality);
    % from one side to the other
    ct = cbrewer_hint('seq','YlGnBu',5,'linear');
    colormap(ct);
    colorbar;
    set(gca, 'Clim', [0,1]);
end

if(strcmpi(options.plot_timing, 'true') && strcmpi(options.plot_seasonality, 'false'))
    % plot timing
    geoshow_global(timing);
    % from one side to the other
    ct_left = cbrewer_hint('div','Spectral',8,'linear');
    ct_right = flipud(cbrewer_hint('div','Spectral',8,'linear'));
    % ct_left = turbo(12);
    % ct_right = flipud(turbo(12));
    ct = [ct_left(1:6,:);ct_right(1:6,:)];
    colormap(ct);
    colorbar;
    set(gca, 'Clim', [0,12]);
end

if(strcmpi(options.plot_seasonality, 'true') && strcmpi(options.plot_timing, 'true'))
    % plot timing
    figure;
    % subplot(2,1,1)
    geoshow_global(seasonality);
    % from one side to the other
    ct = cbrewer_hint('seq','YlGnBu',10,'linear');
    colormap(ct);
    c = colorbar;
    c.Label.String = 'Seaonality';
    set(gca, 'Clim', [0,1]);

    figure;
    % subplot(2,1,2)
    geoshow_global(timing);
    ct_left = cbrewer_hint('div','Spectral',8,'linear');
    ct_right = flipud(cbrewer_hint('div','Spectral',8,'linear'));
    ct = [ct_left(1:6,:);ct_right(1:6,:)];
    colormap(ct);
    colorbar;
    c = colorbar;
    c.Label.String = 'Timing (month)';
    set(gca, 'Clim', [0,12]);
end

% Return both seasonality and timing
% return(list(timing,seasonality))
end

