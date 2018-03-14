%
% Author: Jessica Gonzalez, Stephanie Kemna
% Institution: University of Southern California
% Date: Summer 2017
%
% Creates curtainplots for all sensors in the subset, for a single log file
%
% tested with MatlabR2018a on Ubuntu 16.04
%

run set_sensors_subset

[filename, pathname] = uigetfile('*.log', 'Select a single .log file');
file_path = strcat(pathname, filename);

for  element = 1 : length(sensors_subset)
  curtain_plot_by_type(sensors_subset{element}, file_path)
end