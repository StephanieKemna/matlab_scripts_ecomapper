
% Pop up box with all sensor options
sensors_cell = {'odo', 'chl', 'water_depth', 'water_depth_dvl', 'sp_cond',...
    'sal', 'pH', 'bga', 'temp', 'temp2'};
[dialogue_box] = listdlg('PromptString', 'Select a file:', 'SelectionMode',...
    'single', 'ListString', sensors_cell);
data_type = sensors_cell{dialogue_box};

run em_prepare_labels

% Importing file into matlab cell
[filename, Pathname] = uigetfile('*.log', 'Select the data file', ... 
   '/home/jessica/data_em/Logs/puddingstone_20170627/20170627_193227_UTC_0_jessica_mission1_IVER2-135.log');
file_path = strcat(Pathname, filename);

% Changing the .log file into .mat, while specifying data_type 
filename_mat = strcat(Pathname, filename(1:length(filename)-4), '_', data_type, '.mat');

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
three_dimensional_slice = surf(lon_copies, lat_copies, -depth_copies, grid_data_values);
shading interp
colorbar
title(type_string)
xlabel('Longitude')
ylabel('Latitude')
zlabel('Depth')


