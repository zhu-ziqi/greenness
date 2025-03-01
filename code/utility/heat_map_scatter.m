function heat_map_scatter(X,Y)
% Plot Heatmap
% Input: X,Y should be vector
% Note: NaN shoul be ignored

% filter data (NaN shoul be ignored)
index = isnan(X) | isnan(Y);
X = X(~index);
Y = Y(~index);

Xmin=min(X);Xmax=max(X);
Ymin=min(Y);Ymax=max(Y);


% t=[0:0.001:1].^1.0;
% X=0.5*(t).*cos(618*pi*t)+0.5;
% Y=0.5*(t).*sin(618*pi*t)+0.5;
% Xmin=0;Xmax=1;Ymin=0;Ymax=1;

%加密划分区间
Nx=1000;
Ny=1000;

Xedge=linspace(Xmin,Xmax,Nx);
Yedge=linspace(Ymin,Ymax,Ny);

%N的xy定义是转置的
[N,~,~,binX,binY] = histcounts2(X,Y,[-inf,Xedge(2:end-1),inf],[-inf,Yedge(2:end-1),inf]);

XedgeM=movsum(Xedge,2)/2;
YedgeM=movsum(Yedge,2)/2;

[Xedgemesh,Yedgemesh]=meshgrid(XedgeM(2:end),YedgeM(2:end));

%绘制pcolor图
if(false)
    figure(1)
    pcolor(Xedgemesh,Yedgemesh,N');shading interp
end

%滤波平滑
%h=ones(round(Nx/20));
%h=fspecial('disk',round(Nx/40));
h = fspecial('gaussian',round(Nx/20),6);%最终选用高斯滤波
% N-D filtering of multidimensional images
% Apply the filter to the original image to create an image with motion blur.
% 产生模糊的效应
N2=imfilter(N,h);
if(false)
    figure(2)
    % pcolor(C) creates a pseudocolor plot using the values in matrix C.
    s = pcolor(Xedgemesh,Yedgemesh,N2');shading interp
    % To interpolate the colors across the faces, 
    % set the FaceColor propery of s to 'interp'.
    % s.FaceColor = 'interp';
    % colormap('parula');
    colorbar
end

ind = sub2ind(size(N2),binX,binY);
col = N2(ind);


% figure
% marker_size = 8;
marker_size = 10;
% scatter(x,y,sz,c) specifies the circle colors. 
scatter(X,Y,marker_size,col,'filled');
% colormap(flipud(autumn));
% colorbar;
box on

if(false)
    figure(4)
    plot(X,Y,'.');
end
end


