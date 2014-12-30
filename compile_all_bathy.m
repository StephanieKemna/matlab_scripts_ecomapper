%
% function [] = compile_all_bathy(data_path_prefix, lakename)
% Create a bathy.mat file from grabbing all data from EcoMapper log files
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
function [] = compile_all_bathy(data_path_prefix, location)

if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end
if nargin < 2
    location = 'puddingstone';
end

filename = [data_path_prefix 'bathy_' location '.mat'];
if exist(filename)
    disp('bathy file already exists, returning');
    return
end

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
        log = importdata(fullfile(data_path_prefix,pudd(idx).name,logfiles(idy).name),';');
        if ( isfield(log,'textdata') )
            % grab only what we are interesting in, in this case:
            % textdata col 1: latitude, col 2: longitude, col 17: total water column
            % (assumes EcoMapper standard log file format)
            lat = log.textdata(:,1);
            latitude = str2double(lat(2:size(lat,1)));
            lon = log.textdata(:,2);
            longitude = str2double(lon(2:size(lon,1)));
            depth = log.textdata(:,17);
            lake_depth = str2double(depth(2:size(depth,1)));

            for ( dat = 1:size(latitude,1) )
                if ( lake_depth < 999 ) % filter out erroneous data
                    cnt = cnt+1;
                    data(cnt,:) = [longitude(dat) latitude(dat) lake_depth(dat)];
                end
            end

        end
    end
end

% store the bathy lat/lon/depth file
save(filename,'data');

end
