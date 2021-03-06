%
% function [] = map_all (data_path_prefix, b_localtime, b_dst, mapfile, location, pre_2017, save_figs)
%
%  data_path_prefix: no default; define where to search for log files
%                   (day/mission folder)
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%  mapfile: path to a geotiff on top of which the data can be plotted
%           (default: '~/Maps/puddingstone/puddingstone_dam_extended.tiff')
%  location: experiment location (default: 'puddingstone')
%  pre_2017: turbidity sensor only pre 2017 (0 or 1, default: 0)
%  save_figs: whether or not to store a .jpeg and .fig (default: 1)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: sometime 2015, Spring 2016
%
% tested with MatlabR2018a on Ubuntu 16.04
%
function [] = map_all (data_path_prefix, b_localtime, b_dst, mapfile, location, pre_2017, save_figs)

%% input / preparation
% argument defaults
if nargin < 1
  data_path_prefix = uigetdir('~','Select a folder that contains .log files');
end
if nargin < 2
  b_localtime = 1;
end
if nargin < 3
  b_dst = 1;
end
if nargin < 4
  mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 5
  location = 'puddingstone';
end
if nargin < 6
  pre_2017 = 0;
end
if nargin < 7
  save_figs = 1;
end

disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['mapfile: ' mapfile])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)]);
disp(['DST (bool): ' num2str(b_dst)]);
disp(['pre_2017 (bool): ' num2str(pre_2017)])

%% run for all possible data types
if ( pre_2017 )
  labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};
else
  labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','bga','temp','temp2'};
end

for l_idx = 1:length(labels)
  map_data_from_ecomapper_by_type(labels{l_idx}, mapfile, data_path_prefix, location, b_localtime, b_dst, 0, save_figs);
end

end
