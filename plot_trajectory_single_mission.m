%
% function [] = plot_trajectory_single_mission(logfile_path)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Sep 28, 2016 - Mar 2018
%
% last tested with MatlabR2018a on Ubuntu 16.04
%
function [] = plot_trajectory_single_mission(logfile_path)

%% input/preparation
if nargin < 1
  [filenm, pathnm, ~] = uigetfile('*.log','Select a .log file');
  logfile_path = strcat(pathnm, filenm);
end

%% read data
% using csvimport (Ashish Sadanandan)
% get it from www.mathworks.com/matlabcentral/fileexchange/23573-csvimport
addpath('../csvimport/');

log_data = csvimport(logfile_path, 'delimiter', ';');

% find the columns with lat, lon
lat_idx = find(strcmp(log_data(1,:),'Latitude'),1);
lon_idx = find(strcmp(log_data(1,:),'Longitude'),1);

% grab only what we are interesting in, in this case:
% note: assuming data are numeric
latitude = cell2mat(log_data(2:end,lat_idx));
longitude = cell2mat(log_data(2:end, lon_idx));

%% plot
% prep figure
figure('Position',[0 0 2000 1200]);

% plot the data, colored by level of dissolved oxygen
plot(longitude, latitude, 'b-', 'LineWidth', 3)

xlabel('longitude')
ylabel('latitude')

% make all text in the figure to size 16
finish_font

end
