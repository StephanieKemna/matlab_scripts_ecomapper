function [] = compile_all_bathy(data_path_prefix)

if nargin < 1
    data_path_prefix = '~/data_em/logs/';
end

filename = [data_path_prefix 'bathy.mat'];
if exist(filename)
    disp('bathy file already exists, returning');
    return
end

cnt = 0;
pudd = dir([data_path_prefix 'puddingstone_*']);
for idx = 1:size(pudd,1)
    
    logfiles = dir(fullfile(data_path_prefix,pudd(idx).name,'*.log'));
    for idy = 1:size(logfiles,1)
        disp(strcat('adding: ',logfiles(idy).name))
        log = importdata(fullfile(data_path_prefix,pudd(idx).name,logfiles(idy).name),';');
        if ( isfield(log,'textdata') )
            % textdata col 1: latitude, col 2: longitude, col 17: total water column
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