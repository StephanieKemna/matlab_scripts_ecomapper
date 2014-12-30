%
% function [] = map_puddingstone_depth_interpolated (mapfile, data_path_prefix)
% Plot an interpolated grid of the bathymetry data measured by the
% EcoMapper
%  default mapfile: '~/Maps/puddingstone/puddingstone_dam_extended.tiff'
%  default data_path_prefix: '~/data_em/logs/';
%
% nb. this uses EM compass information, which has drift underwater,
%     ie. there will be jumps on surfacing, and thus the at-depth readings 
%     can be slightly wrong
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Dec 30, 2014
%
function [] = map_puddingstone_depth (mapfile, data_path_prefix)

%% check arguments, construct bathy file(name)
if nargin < 1
    mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 2
    data_path_prefix = '~/data_em/logs/';
end
filename = [data_path_prefix 'bathy.mat'];

% create data file if necessary
if ~exist(filename)
    disp('bathy file non-existent, calling compile_all_bathy');
    compile_all_bathy()
end

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

% plot background
[A, R] = geotiffread(mapfile);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

%% load data
load(filename);

%% plot bathy colors
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled');

%% finish figure
title('Puddingstone EM measured lake depth')
ylabel('latitude')
xlabel('longitude')
colorbar;
minDepth = min(data(:,3));
maxDepth = max(data(:,3));
caxis([minDepth maxDepth]);
% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

end