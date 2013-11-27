%
% function [] = bathy_log_to_mat(basepath, postfix, bathy_mat_filename)
%   basepath: 
%      folder where to look for files, eg. '../../deployments/'
%   postfix:
%      postfix to append to the basepath, eg. 'puddingstone_*', default: ''
%   bathy_mat_filename: 
%      how to save the resulting bathy file, default: 'bathy.mat'
%
% author: Stephanie Kemna
% institute: University of Southern California
% date: 2013-01-30
%
function [] = bathy_log_to_mat(basepath, postfix, bathy_mat_filename) 

%% prep
start = cd;
% fix in case second argument not given
if ( nargin == 1 )
    postfix = '';
end

% go to the folder and retrieve its full path
cd(basepath)
pause(1)
bpath = cd;

%% read the data
cnt = 0;
trial_dirs = horzcat(bpath,'/',postfix);
pudd = dir(trial_dirs);

for idx = 1:size(pudd,1)
    logfiles = dir(fullfile('/',bpath,pudd(idx).name,'logs/*.log'));
    for idy = 1:size(logfiles,1)
        disp(strcat('adding: ',logfiles(idy).name))
        fl = fullfile(bpath,pudd(idx).name,'logs/',logfiles(idy).name);
        log = importdata(fl, ';');
        if ( isfield(log,'textdata') )
            % textdata col 1: latitude, col 2: longitude, col 17: total water column
            % warning: this is hardcoded.. better make sure it is correct..
            lat = log.textdata(:,1);
            latitude = str2double(lat(2:size(lat,1)));
            lon = log.textdata(:,2);
            longitude = str2double(lon(2:size(lon,1)));
            depth = log.textdata(:,17);
            lake_depth = str2double(depth(2:size(depth,1)));
            
            % check if the data is coherent, else maybe the hardcoded
            %                                columns are incorrect
            if ( not((size(latitude,1) == size(longitude,1)) & (size(latitude,1) == size(lake_depth,1))) )
                disp('WARNING: non-equal amounts of latitude, longitude and lake_depth measurements');
            end
            
            for ( dat = 1:size(latitude,1) )
                if ( lake_depth < 999 ) % filter out erroneous data
                    cnt = cnt+1;
                    data(cnt,:) = [longitude(dat) latitude(dat) lake_depth(dat)];
                end
            end
        end
    end
end
disp(horzcat('processed ',num2str(cnt),' data pnts'));

cd(start);

%% store the extracted data
% fix in case third argument not given 
if ( nargin < 3 )
    bathy_mat_filename = 'bathy.mat';
end
disp(horzcat('storing data in: ',bathy_mat_filename));
save(bathy_mat_filename, 'data');

end