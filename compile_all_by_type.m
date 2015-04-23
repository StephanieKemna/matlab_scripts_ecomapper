%
% function [] = compile_all_by_type(data_type, data_path_prefix, location)
% Create a <type>.mat file from grabbing all data from EcoMapper log files
% for the specified location.
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone'
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = compile_all_by_type(data_type, data_path_prefix, location)

%% input / preparation
if nargin < 1
    disp('Error, please provide data type.')
    disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga');
    return
end
if nargin < 2
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 3
    location = 'puddingstone';
end
disp('Using:')
disp(['type: ' data_type])
disp(['data_path_prefix' data_path_prefix])
disp(['location: ' location])

% construct file location / name
filename = [data_path_prefix data_type '_' location '.mat'];
if exist(filename,'file')
    disp([data_type ' file already exists, returning']);
    return
end

% prepare labels
run em_prepare_labels

%% read data
% using csvimport (Ashish Sadanandan)
% get it from www.mathworks.com/matlabcentral/fileexchange/23573-csvimport
addpath('../csvimport/');

cnt = 0;
% get all subfolders
pudd = dir([data_path_prefix location '_*']);
for idx = 1:size(pudd,1)
    % get all log files in folder
    logfiles = dir(fullfile(data_path_prefix,pudd(idx).name,'*.log'));
    for idy = 1:size(logfiles,1)
        % feedback to user about what's being included
        disp(strcat('adding: ',logfiles(idy).name))
        % get the data

        % import the data into a big table, 
        % using csvimport (Ashish Sadanandan)
        log_data = csvimport(fullfile(data_path_prefix,pudd(idx).name,logfiles(idy).name),'delimiter',';');

        % find the columns with lat, lon, ODO
        lat_idx = find(strcmp(log_data(1,:),'Latitude'),1);
        lon_idx = find(strcmp(log_data(1,:),'Longitude'),1);

        desired_data_idx = find(strcmp(log_data(1,:),type_string),1);

        dep_idx = find(strcmp(log_data(1,:),'DFS Depth (m)'),1);
        time_idx = find(strcmp(log_data(1,:),'Time'),1);
        date_idx = find(strcmp(log_data(1,:),'Date'),1);
        
        % grab only what we are interesting in, in this case:
        % note: assuming data are numeric
        latitude = cell2mat(log_data(2:end,lat_idx));
        longitude = cell2mat(log_data(2:end, lon_idx));
        desired_data = cell2mat(log_data(2:end, desired_data_idx));
        depth = cell2mat(log_data(2:end, dep_idx));        
        time = log_data(2:end, time_idx);
        date = log_data(2:end, date_idx);
        
        dnum = zeros(length(time),1);
        for ( idx_dnum = 1:length(time) )
          dnum(idx_dnum) = datenum(datestr([date{idx_dnum} ' ' time{idx_dnum}]));
        end
        
        % some files have only 0s in the data, if so, this is likely
        % incorrect, so we discard the data
        % if we need the entries, we could adapt this later
        if ( max(desired_data) ~= 0 )
            % add current file's data points to big matrix
            for ( dat = 1:length(latitude) )
                cnt = cnt+1;
                data(cnt,:) = [longitude(dat) latitude(dat) desired_data(dat) dnum(dat) depth(dat)];
            end
        end
    end
end

%% save
% store the lat/lon/ODO file
save(filename,'data');

end
