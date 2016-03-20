function [] = map_all (data_path_prefix, mapfile, location)

if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
    mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 3
    location = 'puddingstone';
end

disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['mapfile: ' mapfile])
disp(['location: ' location])


%% run for all possible data types
labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};

for l_idx = 1:length(labels),
    map_data_from_ecomapper_by_type(labels{l_idx}, mapfile, data_path_prefix, location);
end


end