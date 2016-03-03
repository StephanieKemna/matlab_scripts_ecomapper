function [] = compile_all(data_path_prefix, multiple_folders, location)

%% input / preparation
if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
    multiple_folders = 0;
end
if nargin < 3
    location = 'puddingstone';
end
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['multiple folders? ' num2str(multiple_folders)])
disp(['location: ' location])

%% run for all possible data types
labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};

for l_idx = 1:length(labels),
    compile_all_by_type(labels{l_idx}, data_path_prefix, multiple_folders, location);
end

