%
% function [] = plot_all_by_date(dd, mm, yyyy, data_path_prefix, b_localtime, b_dst, location)
%
%  dd, mm, yyyy: date specified by day(2) month(2) and year(4)
%  data_path_prefix: no default; define where to search for log files
%                   (day/mission folder)
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%  multiple_folders: find log files in multiple mission folders? (0 or 1, default: 0)
%  location: experiment location, default: 'puddingstone'
%
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Spring 2016
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = plot_all_by_date(dd, mm, yyyy, data_path_prefix, b_localtime, b_dst, location)

%% input / preparation
if nargin < 4
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 5
    b_localtime = 0;
end
if nargin < 6
    b_dst = 0;
end
if nargin < 7
    location = 'puddingstone';
end
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])

%% run for all possible data types
labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};

for l_idx = 1:length(labels),
    disp(labels{l_idx})
    plot_em_type_date(dd, mm, yyyy, labels{l_idx}, data_path_prefix, location, b_localtime, b_dst);
end

