%
% function [] = compile_all_by_type(data_type, folder, data_path_prefix, location, b_localtime, b_dst)
% Create a <type>.mat file from grabbing all data from EcoMapper log files
% for the specified location.
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default data_path_prefix: '~/data_em/logs/'
%  default multiple_folders? (bool): 0 (process one folder, choose 1 for
%  processing multiple)
%  default location: 'puddingstone'
%  default b_localtime: 0 (false, using UTC time)
%  default b_dst: 0 (false, not on daylight-savings-time)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015 - May 2016
%
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = compile_all_by_type(data_type, data_path_prefix, multiple_folders, location, b_localtime, b_dst)

%% input / preparation
if nargin < 1
  disp('Error, please provide data type.')
  disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga');
  disp('Usage: compile_all_by_type(data_type, data_path_prefix=~/data_em/logs/, location=puddingstone');
  return
end
if nargin < 2
  data_path_prefix = '~/data_em/logs/';
end
if nargin < 3
  multiple_folders = 0;
end
if nargin < 4
  location = 'puddingstone';
end
if nargin < 5
  b_localtime = 0;
end
if nargin < 6
  b_dst = 0;
end
disp('Using:')
disp(['type: ' data_type])
disp(['data_path_prefix: ' data_path_prefix])
disp(['multiple folders? ' num2str(multiple_folders)])
disp(['location: ' location])
disp(['local time (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])

if ( strcmp(data_path_prefix(end),'/') == 0 )
  data_path_prefix = [data_path_prefix '/']
end

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
if ( multiple_folders )
  pudd = dir([data_path_prefix location '_*']);
else
  pudd = 1;
end
for idx = 1:size(pudd,1)
  % get all log files in folder
  if ( multiple_folders )
    logfiles = dir(fullfile(data_path_prefix,pudd(idx).name,'*.log'));
  else
    logfiles = dir(fullfile(data_path_prefix,'*.log'));
  end
  for idy = 1:size(logfiles,1)
    % feedback to user about what's being included
    disp(strcat('adding: ',logfiles(idy).name))
    % get the data
    
    % import the data into a big table,
    % using csvimport (Ashish Sadanandan)
    if ( multiple_folders )
      [latitude, longitude, depth, time, date, desired_data_cells] = ...
        csvimport(fullfile(data_path_prefix,pudd(idx).name,logfiles(idy).name), ...
        'columns',{'Latitude','Longitude','DFS Depth (m)','Time','Date',type_string}, ...
        'delimiter',';');
    else
      [latitude, longitude, depth, time, date, desired_data_cells] = ...
        csvimport(fullfile(data_path_prefix,logfiles(idy).name), ...
        'columns',{'Latitude','Longitude','DFS Depth (m)','Time','Date',type_string}, ...
        'delimiter',';');
    end
    
    dnum = zeros(length(time),1);
    for ( idx_dnum = 1:length(time) )
      dnum(idx_dnum) = datenum(datestr([date{idx_dnum} ' ' time{idx_dnum}]));
    end
    
    % time on EM is now stored as UTC - convert to local?
    if ( b_localtime )
      hour = 1/24;
      if ( b_dst )
        offset = -7*hour;
      else
        offset = -8*hour;
      end
      time_fixed = dnum + offset;
    else
      time_fixed = dnum;
    end
    
    % convert cells to numbers,
    % but check if there are gaps in the data, and if so, filter out
    if ( iscell(desired_data_cells) )      
      if ( sum(cellfun(@isempty,desired_data_cells)) == 0 )
        desired_data = cell2mat(desired_data_cells);
      else
        cell_mask = ~cellfun(@isempty,desired_data_cells);

        % filter the data
        latitude = latitude(cell_mask);
        longitude = longitude(cell_mask);
        desired_data = cellfun(@str2num,desired_data_cells(cell_mask));
        depth = depth(cell_mask);
        time_fixed = time_fixed(cell_mask);
      end
    else
      desired_data = desired_data_cells;
    end
    
    % some files have only 0s in the data, if so, this is likely
    % incorrect, so we discard the data
    % if we need the entries, we could adapt this later
    if ( max(desired_data) ~= 0 )
      % add current file's data points to big matrix
      for dat = 1:length(desired_data)
        cnt = cnt+1;
        data(cnt,:) = [longitude(dat) latitude(dat) desired_data(dat) time_fixed(dat) depth(dat)];
      end
    else
      disp('max of data to store is 0, not storing');
    end
  end
end

%% save
% store the lat/lon/ODO file
if ( exist('data','var') == 1 )
  save(filename,'data');
else
  disp('error, no data stored');
end

end
