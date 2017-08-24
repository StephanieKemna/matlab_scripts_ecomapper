% function [] = curtainplot_sensors_subset_per_folder(folder)
%
function [] = curtainplot_sensors_subset_per_folder(folder, location, save_figs)

%% prep/params
if ~exist('folder','var')
  uigetdir;
end
if ~exist('location','var')
  location = 'puddingstone';
end
if ~exist('save_figs','var')
  save_figs = 0;
end

% get all files from folder
logfiles = dir(fullfile(folder,'*.log'));

% define subset, sets 'sensors_subset'
run set_sensors_subset

% fix path, if necessary, to end with slash
if ( folder(length(folder)) ~= '/' )
  folder = strcat(folder,'/');
end

%% run curtain_plot_by_type

% iterate over all log files, 
% create curtain plot for each
for file_id = 1:length(logfiles),
  file_path = strcat(folder, logfiles(file_id).name);
  disp(['Logfile: ' logfiles(file_id).name]);

  for  element = 1:length(sensors_subset)
    curtain_plot_by_type(sensors_subset{element}, file_path, location, save_figs)
    disp(['Plot: ' num2str(gcf)])
  end
end