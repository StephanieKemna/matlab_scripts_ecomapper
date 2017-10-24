%
% function [] = plot_all_3d(data_path_prefix, b_localtime, b_dst, location, pre_2017)
%
%  data_path_prefix: no default; define where to search for log files
%                   (day/mission folder)
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%  multiple_folders: find log files in multiple mission folders? (0 or 1, default: 0)
%  location: experiment location, default: 'puddingstone'
%  pre_2017: turbidity sensor only pre 2017 (0 or 1, default: 0)
%
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Spring 2016
%
% tested with MatlabR2012a on Ubuntu 16.04
%
function [] = plot_all_2d(data_path_prefix, b_localtime, b_dst, location, pre_2017)

%% input / preparation
if nargin < 1
  % interactive choice of data dir, if none given
  data_path_prefix = uigetdir;
end
if nargin < 2
  b_localtime = 1;
end
if nargin < 3
  b_dst = 1;
end
if nargin < 4
  location = 'puddingstone';
end
if nargin < 5
  pre_2017 = 0;
end
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])
disp(['pre_2017 (bool): ' num2str(pre_2017)])

%% run for all possible data types
if ( pre_2017 ) 
  labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};
else
  labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','bga','temp','temp2'};  
end

for l_idx = 1:length(labels),
  disp(labels{l_idx})
  plot_em_by_type(labels{l_idx}, data_path_prefix, location, b_localtime, b_dst, 1);
end

