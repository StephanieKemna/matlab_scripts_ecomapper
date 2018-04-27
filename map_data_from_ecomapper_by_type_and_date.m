%
% function [] = map_data_from_ecomapper_by_type_and_date (data_type, dd, mm, yyyy, mapfile, data_path_prefix, location)
% Plot an interpolated grid of the bathymetry data measured by the
% EcoMapper
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  date: dd day, mm month, yyyy year
%  default mapfile: '~/Maps/puddingstone/puddingstone_dam_extended.tiff'
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone'
%
% nb. this uses EM compass information, which has drift underwater,
%     ie. there will be jumps on surfacing, and thus the at-depth readings
%     can be slightly wrong
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015, adapted from map_bathynetry_from_ecomapper
%
% last tested with MatlabR2012a (without mapping toolbox) on Ubuntu 16.04
%
function [] = map_data_from_ecomapper_by_type_and_date (data_type, dd, mm, yyyy, mapfile, data_path_prefix, location)

%% input/preparation
% check arguments, construct bathy file(name)
if nargin < 1
  disp('Error! No data_type and date defined')
  disp('Usage: map_data_from_ecomapper_by_type_and_date (data_type, dd, mm, yyyy, mapfile, data_path_prefix, location')
  disp('Data type options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
  return
end
if nargin < 4
  disp('Error! You need to provide a date')
  disp('Usage: map_data_from_ecomapper_by_type_and_date (data_type, dd, mm, yyyy, mapfile, data_path_prefix, location)')
  return
end
if nargin < 5
  mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 6
  data_path_prefix = '~/data_em/logs/';
end
if nargin < 7
  location = 'puddingstone';
end

if ( strcmp(data_path_prefix(end),'/') == 0 )
  data_path_prefix = [data_path_prefix '/'];
end

filename = [data_path_prefix data_type '_' location '.mat'];

% create data file if necessary
if ~exist(filename,'file')
  disp('data file non-existent, calling compile_all_by_type');
  compile_all_by_type(data_type, data_path_prefix, location)
end

% prepare labels
run em_prepare_labels

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

if ( license('test','mapping_toolbox') )
  % add geo-referenced map as background
  [A, R] = geotiffread(mapfile);
  mapshow(A,R);
  axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])
end
  
%% load data
load(filename);
longitude = data(:,1);
latitude = data(:,2);
desired_data = data(:,3);
time_datenum = data(:,4);

%% extract data by date
% construct desired date
date_desired = datestr([num2str(mm) '-' num2str(dd) '-' num2str(yyyy)])

cnt = 0;
for ( idx = 1:length(desired_data) )
  % compare the date
  if ( strncmp(date_desired, datestr(time_datenum(idx)), 11) )
    cnt = cnt + 1;
    nw_lon(cnt) = longitude(idx);
    nw_lat(cnt) = latitude(idx);
    nw_data(cnt) = desired_data(idx);
  end
end

%% plot bathy colors
scatter( nw_lon, nw_lat, 10, nw_data, 'filled');

%% finish figure
title([location ' EM measured ' type_title_string])
ylabel('latitude')
xlabel('longitude')
cb = colorbar;
minData = min(data(:,3));
maxData = max(data(:,3));
caxis([minData maxData]);
set(get(cb,'Title'),'String',type_title_string);

% make all text in the figure to size 16
finish_font

end
