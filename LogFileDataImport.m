
% Pop up box with all sensor options
sensors_cell = {'odo', 'chl', 'water_depth', 'water_depth_dvl', 'sp_cond',...
    'sal', 'pH', 'bga', 'temp', 'temp2'};
[dialogue_box] = listdlg('PromptString', 'Select a file:', 'SelectionMode',...
    'single', 'ListString', sensors_cell);
data_type = sensors_cell{dialogue_box};

run em_prepare_labels

% Importing file into matlab cell
[filename, Pathname] = uigetfile('*.log', 'Select the data file');
file_path = strcat(Pathname, filename);
all_data = csvimport(file_path, 'delimiter',';'); % Places all data set into large cell

% Extract the first row from the file
first_row = (all_data(1,:));

% Create a string for Latitude 
latitude_index = find_index(first_row, 'Latitude'); 

% Create string for Longitude
longitude_index = find_index(first_row, 'Longitude');

% Create string for generic data (sensors_cell options)
generic_index = find_index(first_row,type_string); 

% Create string for Depth
depth_index = find_index(first_row, 'DFS Depth (m)'); 



% Extracts data from specific column from file/cell
latitude_column = [all_data{2:size(all_data,1),latitude_index}];

longitude_column = [all_data{2:size(all_data,1),longitude_index}];

depth_column = [all_data{2:size(all_data,1),depth_index}];

generic_column = [all_data{2:size(all_data,1),generic_index}];

% Longitude min and max
min_lon = min(longitude_column);
max_lon = max(longitude_column);

% Latitude min and max
min_lat = min(latitude_column);
max_lat = max(latitude_column);

% Depth min and max
min_dep = min(depth_column);
max_dep = max(depth_column);

% Range of latitude, longitude, and depth
lat_range = max_lat - min_lat;
lon_range = max_lon - min_lon;
dep_range = max_dep - min_dep;

num_steps = 100;

% Step size of latitude, longitude, and depth
lat_step_size = lat_range/num_steps;
lon_step_size = lon_range/num_steps;
dep_step_size = dep_range/num_steps;

% Creating the meshgrid necessary for interpolation
[lon_interp,lat_interp,dep_interp] = meshgrid(min_lon:lon_step_size:max_lon,...
    min_lat:lat_step_size:max_lat,min_dep:dep_step_size:max_dep);

% Extracting unique values from the data
matrix_data=[longitude_column', latitude_column', depth_column'];
[unique_values,IA] = unique(matrix_data, 'rows', 'stable');
generic_unique= generic_column(IA);
lon_unique= longitude_column(IA);
lat_unique= latitude_column(IA);
dep_unique= depth_column(IA);

% Interpolation command to generate plots inbetween sampled data
generic_interp = griddata(lon_unique, lat_unique, dep_unique, generic_unique,...
    lon_interp, lat_interp, dep_interp);

slice(lon_interp, lat_interp, dep_interp, generic_interp, -117.808, 34.0885, 0)



