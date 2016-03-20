%
% function [] = plot_all(data_path_prefix, location)
%
function [] = plot_all(data_path_prefix, location)

%% input / preparation
if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
    location = 'puddingstone';
end
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['location: ' location])

%% run for all possible data types
labels = {'odo','chl','water_depth','water_depth_dvl','sp_cond','sal',...
    'pH','turb','bga','temp','temp2'};

for l_idx = 1:length(labels),
    disp(labels{l_idx})
    plot_em_by_type(labels{l_idx}, data_path_prefix, location);
end

