%
% function [] = compile_all_DO(data_path_prefix, lakename)
% Create a DO.mat file from grabbing all data from EcoMapper log files
% for the specified location.
%  default data_path_prefix: '~/data_em/logs/';
%  default location: 'puddingstone';
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Dec 30, 2014
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = compile_all_ODO(data_path_prefix, location)

if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
    location = 'puddingstone';
end

filename = [data_path_prefix 'ODO_' location '.mat'];
if exist(filename)
    disp('bathy file already exists, returning');
    return
end

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
        odo_idx = find(strcmp(log_data(1,:),'ODO mg/L'),1);
        dep_idx = find(strcmp(log_data(1,:),'DFS Depth (m)'),1);
        time_idx = find(strcmp(log_data(1,:),'Time'),1);
        date_idx = find(strcmp(log_data(1,:),'Date'),1);
        
        % grab only what we are interesting in, in this case:
        % note: assuming data are numeric
        latitude = cell2mat(log_data(2:end,lat_idx));
        longitude = cell2mat(log_data(2:end, lon_idx));
        odo = cell2mat(log_data(2:end, odo_idx));
        depth = cell2mat(log_data(2:end, dep_idx));        
        time = cell2mat(log_data(2:end, time_idx));
        date = cell2mat(log_data(2:end, date_idx));
        
        % TODO datenum(datestr([date1 ' ' time1]))
        
        % some files have only 0s in the data, if so, this is likely
        % incorrect, so we discard the data
        % if we need the entries, we could adapt this later
        if ( max(odo) ~= 0 )
            % add current file's data points to big matrix
            for ( dat = 1:length(latitude) )
                cnt = cnt+1;
                data(cnt,:) = [longitude(dat) latitude(dat) odo(dat)];
            end
        end
    end
end

% store the lat/lon/ODO file
save(filename,'data');

end
