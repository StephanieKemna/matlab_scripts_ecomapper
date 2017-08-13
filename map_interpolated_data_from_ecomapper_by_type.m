%
% function [] = map_interpolated_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location)
% Plot an interpolated grid of the specified data measured by the
% EcoMapper
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default mapfile: '~/Maps/puddingstone/puddingstone_dam_extended.tiff'
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone'
%
% nb. this uses EM compass information, which has drift underwater,
%     ie. there will be jumps on surfacing, and thus the at-depth readings
%     can be slightly wrong
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Dec 8, 2015, adapted from map_interpolated_bathymetry_from_ecomapper
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = map_interpolated_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location)

%% check arguments, construct bathy file(name)
if nargin < 1
  disp('Error! No data_type defined')
  disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
  disp('Usage: map_interpolated_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location)')
  disp('For more info, type: help map_interpolated_data_from_ecomapper_by_type')
  return
end
if nargin < 2
  mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 3
  data_path_prefix = '~/data_em/logs/';
end
if nargin < 4
  location = 'puddingstone';
end

if ( strcmp(data_path_prefix(end),'/') == 0 )
  data_path_prefix = [data_path_prefix '/']
end

filename = [data_path_prefix data_type '_' location '.mat'];
% decide whether or not to save as csv
save_csv = 0;

% create data file if necessary
if ~exist(filename,'file')
  disp('data file non-existent, calling compile_all_by_type');
  compile_all_by_type(data_type, data_path_prefix, location)
end

% prepare labels
run em_prepare_labels

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map as background
[A, R] = geotiffread(mapfile);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

%% load data
load(filename);

%% interpolate

% note, to exclude erroneous data, limit to the map we are making
% exclude out of bounds data
data = data(data(:,1)>R.Lonlim(1),:);
data = data(data(:,1)<R.Lonlim(2),:);
data = data(data(:,2)>R.Latlim(1),:);
data = data(data(:,2)<R.Latlim(2),:);
if ( location == 'puddingstone')
  % exclude big data errors
  data = data(data(:,3)<20,:);
end

minLon = min(data(:,1));
maxLon = max(data(:,1));
minLat = min(data(:,2));
maxLat = max(data(:,2));
[X, Y] = meshgrid(linspace(minLon,maxLon,300), linspace(minLat,maxLat,300));

%             longitude, latitude,  depth
zi = griddata(data(:,1), data(:,2), data(:,3), X, Y);

%% plot bathy colors
%scatter( data(:,1), data(:,2), 10, data(:,3), 'filled');
scatter( X(:), Y(:), 10, zi(:), 'filled')

%% finish figure
title([location ' EM measured ' type_title_string])
ylabel('Latitude')
xlabel('Longitude')

cb = colorbar;
minDepth = min(data(:,3));
maxDepth = max(data(:,3));
if (location == 'puddingstone')
  caxis([0 20])
  load('cm_puddingstone_water_depth');
  colormap(flipud(cm))
else
  caxis([minDepth maxDepth]);
end
set(get(cb,'Title'),'String','Depth (m)');

% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

%% other save methods

% store as csv
if ( save_csv )
  all_data = [X(:) Y(:) zi(:)];
  dlmwrite([data_type '_' location '.csv'],all_data, 'delimiter', ',', 'precision', 20)
end
