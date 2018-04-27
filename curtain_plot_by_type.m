% function[] = curtain_plot_by_type(data_type, file_path, location, save_figs)
%
% Create a curtain plot for a single data type, for a single log file
%
% Author: Jessica Gonzalez, Stephanie Kemna
% Institution: University of Southern California
% Date: Summer 2017
%
% tested with MatlabR2018a on Ubuntu 16.04
%
function[] = curtain_plot_by_type(data_type, file_path, location, save_figs)

if ~exist('save_figs','var')
  save_figs = 0;
end
if ~exist('location','var')
  location = 'puddingstone';
end

% Pop up box with all sensor options
sensors_cell = {'odo', 'chl', 'water_depth', 'water_depth_dvl', 'sp_cond',...
  'sal', 'pH', 'bga', 'temp', 'temp2'};
if ( ~exist('data_type','var') )
  [dialogue_box] = listdlg('PromptString', 'Select a file:', 'SelectionMode',...
    'single', 'ListString', sensors_cell);
  data_type = sensors_cell{dialogue_box};
end

run em_prepare_labels

% Importing file into matlab cell
if ~exist('file_path','var')
  [filename, pathname] = uigetfile('*.log', 'Select the data file');
  file_path = strcat(pathname, filename);
end

% Changing the .log file into .mat, while specifying data_type
filename_mat = strcat(file_path(1:length(file_path)-4), '_', data_type, '.mat');

if exist(filename_mat, 'file') == 0
  %Extracting data from each column
  [latitude_column, longitude_column, depth_column, generic_column]= ...
    csvimport(file_path, 'columns', {'Latitude', 'Longitude', 'DFS Depth (m)', ...
    type_string},'delimiter',';');
  
  % Depth min and max
  min_dep = min(depth_column);
  max_dep = max(depth_column);
  
  % Range depth
  dep_range = max_dep - min_dep;
  num_steps = 100;
  
  % Step size of depth
  dep_step_size = dep_range/num_steps;
  
  % ProducesnNumber of copies for Lat & Long (so hardcoding isn't necessary)
  depth_range = min_dep : dep_step_size : max_dep;
  depth_length = length(depth_range);
  
  % Produces the number of copies for Depth
  longitude_length = length(longitude_column);
  
  % Variables necessary for griddata so a cube of informaton isn't produced
  lon_copies = repmat(longitude_column', depth_length, 1);
  lat_copies = repmat(latitude_column', depth_length, 1);
  depth_copies= repmat(depth_range', 1, longitude_length);
  
  % Creating the grid and the values for each axis
  grid_data_values= griddata(longitude_column, latitude_column, depth_column,...
    generic_column, lon_copies, lat_copies, depth_copies);
  
  % Saving the filename_mat with variables
  save(filename_mat, 'lon_copies', 'lat_copies', 'depth_copies', 'grid_data_values');
else
  load(filename_mat)
end

% Plot the completed 3D slice/graph
hFig = figure;
set(hFig, 'Position', [0 0 1000 1000])
three_dimensional_slice = surf(lon_copies, lat_copies, -depth_copies, grid_data_values);
shading interp
colorbar
title(type_string)
xlabel('Longitude')
ylabel('Latitude')
zlabel('Depth')
if ( strcmp(location,'puddingstone') == 1 && strcmp('chl', data_type) == 1 )
  caxis([0 100])
end

focus_map_curtain
finish_font(16)

if ( save_figs )
  data_path_prefix = file_path(1:length(file_path)-4);
  location = 'elsinore';
  prefix = '';
  identifier = 'curtain';
  save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70)
  save_as_fig(hFig, data_path_prefix, location, prefix, 'curtain', data_type);
end

% elsinore plots, consistency
if ( strcmp(location,'elsinore') == 1 && save_figs )
  
  if ( strcmp(data_type,'chl') == 1 )
    caxis([0 50])
    postfix = 'caxis50';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
    caxis([0 65])
    postfix = 'caxis65';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
    caxis([0 90])
    postfix = 'caxis90';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
  
  elseif ( strcmp(data_type,'bga') == 1 )
    caxis([0 100000])
    postfix = 'caxis100k';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
    caxis([0 150000])
    postfix = 'caxis150k';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
    caxis([0 260000])
    postfix = 'caxis260k';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
  elseif ( strcmp(data_type,'odo') == 1 )
    caxis([0 20])
    load('odo-cm.mat')
    colormap(cm)
    postfix = 'caxis20';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)
    
  elseif ( strcmp(data_type,'temp') == 1 )
    caxis([25 34])
    postfix = 'caxis25-34';
    save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 70, postfix)

  end
end

end

