%
% function [] = map_puddingstone_depth_interpolated (mapfile, data_path_prefix, location)
% Plot an interpolated grid of the bathymetry data measured by the
% EcoMapper
%  default mapfile: '~/Maps/puddingstone/puddingstone_dam_extended.tiff'
%  default data_path_prefix: '~/data_em/logs/';
%  default location: 'puddingstone'
%
% nb. this uses EM compass information, which has drift underwater,
%     ie. there will be jumps on surfacing, and thus the at-depth readings 
%     can be slightly wrong
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Initial work in 2013, finished Dec 30, 2014
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = map_interpolated_bathymetry_from_ecomapper (mapfile, data_path_prefix, location)

%% check arguments, construct bathy file(name)
if nargin < 1
    mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 2
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 3
    location = 'puddingstone';
end
filename = [data_path_prefix 'bathy_' location '.mat'];
 
% create data file if necessary
if ~exist(filename)
    disp('bathy file non-existent, calling compile_all_bathy');
    compile_all_bathy(data_path_prefix, location)
end

%% load data
load(filename);

%% interpolation
minLon = min(data(:,1));
maxLon = max(data(:,1));
minLat = min(data(:,2));
maxLat = max(data(:,2));
[X, Y] = meshgrid(linspace(minLon,maxLon,100), linspace(minLat,maxLat,100));
%             longitude, latitude,  depth
zi = griddata(data(:,1), data(:,2), data(:,3), X, Y);

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map as background
[A, R] = geotiffread(mapfile);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

%% plot interpolated data
scatter(X(:),Y(:),10,zi(:))

%% finish figure
cb = colorbar;
minDepth = min(data(:,3));
maxDepth = max(data(:,3));
caxis([minDepth maxDepth])
set(get(cb,'Title'),'String','Depth (m)');

title([location ' interpolated EM measured lake depth'])
ylabel('latitude')
xlabel('longitude')

% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

end