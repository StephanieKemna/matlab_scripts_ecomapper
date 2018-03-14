% function [] = curtainplot_sensors_subset_per_folder(folder)
%
% Creates curtainplots for all sensors specified in 'set_sensors_subset'
% for each log file in the given folder
%
% Author: Jessica Gonzalez, Stephanie Kemna
% Institution: University of Southern California
% Date: Summer 2017
%
% tested with MatlabR2018a on Ubuntu 16.04
%
function [] = curtainplot_sensors_subset_per_folder(foldernm, location, save_figs)

%% prep/params
if ~exist('folder','var')
  foldernm = uigetdir('~','Select a folder that contains .log files');
end
if ~exist('location','var')
  location = 'puddingstone';
end
if ~exist('save_figs','var')
  save_figs = 0;
end

% get all files from folder
logfiles = dir(fullfile(foldernm,'*.log'));

% define subset, sets 'sensors_subset'
run set_sensors_subset

% fix path, if necessary, to end with slash
if ( foldernm(length(foldernm)) ~= '/' )
  foldernm = strcat(foldernm,'/');
end

%% run curtain_plot_by_type

% iterate over all log files, 
% create curtain plot for each
for file_id = 1:length(logfiles)
  file_path = strcat(foldernm, logfiles(file_id).name);
  disp(['Logfile: ' logfiles(file_id).name]);

  for  element = 1:length(sensors_subset)
    curtain_plot_by_type(sensors_subset{element}, file_path, location, save_figs)
  end
end