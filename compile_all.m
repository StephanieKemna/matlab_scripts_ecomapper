%
% function [] = compile_all(data_path_prefix, b_localtime, b_dst, multiple_folders, location)
%
%  data_path_prefix: no default; define where to search for log files
%                   (day/mission folder)
%  b_localtime: convert UTC to local time? (0 or 1, default: 1)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 1)
%  multiple_folders: find log files in multiple mission folders? (0 or 1, default: 0)
%  location: experiment location, default: 'puddingstone'
%
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Spring 2016 - Summer 2017
%
% last tested with MatlabR2018a on Ubuntu 16.04
%
function [] = compile_all(data_path_prefix, b_localtime, b_dst, multiple_folders, location)

run compile_scripts_read_params

%% run for all possible data types
labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
  'pH','turb','bga','temp','temp2'};

for l_idx = 1:length(labels)
  compile_all_by_type(labels{l_idx}, data_path_prefix, multiple_folders, location, b_localtime, b_dst);
end

