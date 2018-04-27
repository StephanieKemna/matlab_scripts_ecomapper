%
% function [] = map_puddingstone_depth_interpolated (mapfile, data_path_prefix, location)
% Plot an interpolated grid of the bathymetry data measured by the
% EcoMapper
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
% Date: Initial work in 2013, finished Dec 30, 2014
%
% last tested with MatlabR2018a (without mapping toolbox) on Ubuntu 16.04
%
function [] = map_bathymetry_from_ecomapper (data_path_prefix, mapfile, location)

%% check arguments, construct bathy file(name)
if nargin < 1
  data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
  mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 3
  location = 'puddingstone';
end

if ( strcmp(data_path_prefix(end),'/') == 0 )
  data_path_prefix = [data_path_prefix '/']
end

filename = [data_path_prefix 'water_depth_' location '.mat'];

% create data file if necessary
if ~exist(filename)
  disp('bathy file non-existent, calling compile_all_bathy');
  compile_all_by_type('water_depth', data_path_prefix, 0, location)
end

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

if ( license('test','mapping_toolbox') )
  % add geo-referenced map as background
  [A, R] = geotiffread(mapfile);
  mapshow(A,R);
  axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])
end

%% load data
load(filename);

%% plot bathy colors
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled');

%% finish figure
title([location ' EM measured lake depth'])
ylabel('latitude')
xlabel('longitude')
cb = colorbar;
minDepth = min(data(:,3));
maxDepth = max(data(:,3));
caxis([minDepth maxDepth]);
set(get(cb,'Title'),'String','Depth (m)');

% flip colors to have blue be deep, limit 25m for Puddingstone
cx = caxis;
if ( strcmp(location,'puddingstone')  == 1 && cx(2) > 25 )
  caxis([0 25]);
end
if ( strcmp(location,'puddingstone')  == 1 )
  load('cm_puddingstone_water_depth.mat')
  colormap(flipud(cm));
end

% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

end
