%
% function [] = map_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location, b_localtime, b_dst, multiple_folders)
%
% Plot data measured by the EcoMapper onto map (tiff)
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default mapfile: '~/Maps/puddingstone/puddingstone_dam_extended.tiff'
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone'
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%
% nb. this uses EM compass information, which has drift underwater,
%     ie. there will be jumps on surfacing, and thus the at-depth readings 
%     can be slightly wrong
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015, adapted from map_bathynetry_from_ecomapper
%
% tested with MatlabR2012a on Ubuntu 16.04
%
function [] = map_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location, b_localtime, b_dst, multiple_folders)

%% check arguments, construct bathy file(name)
if nargin < 1
    disp('Error! No data_type defined')
    disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
    return
end
if nargin < 2
    mapfile = '~/Maps/puddingstone/puddingstone_dam_extended.tiff';
end
if nargin < 3
    data_path_prefix = '~/data_em/logs/';
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
if nargin < 7
  multiple_folders = 0;
end

if ( strcmp(data_path_prefix(end),'/') == 0 )
    data_path_prefix = [data_path_prefix '/']
end

filename = [data_path_prefix data_type '_' location '.mat']

% create data file if necessary
if ~exist(filename,'file')
    disp('data file non-existent, calling compile_all_by_type');
    compile_all_by_type(data_type, data_path_prefix, multiple_folders, location, b_localtime, b_dst)
end
if ~exist(filename,'file')
    disp('data file still non-existent, not plotting');
    return;
end

% prepare labels
run em_prepare_labels

%% prepare figure
fig_h = figure('Position',[0 0 1400 1200]);
hold on

% add geo-referenced map as background
[A, R] = geotiffread(mapfile);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

%% load data
disp(['Loading data for: ' data_type]);
load(filename);

%% plot bathy colors
disp(['Creating scatter plot for: ' data_type]);
% data: lon, lat, data, time, depth
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled');

%% finish figure
title([location ' EM measured ' type_title_string])
ylabel('Latitude')
xlabel('Longitude')
cb = colorbar;

if ( strcmp(data_type,'odo') == 1 )
    caxis([0 20])
    load('odo-cm.mat')
    colormap(cm)
elseif ( strcmp(data_type,'water_depth') == 1 || strcmp(data_type,'water_depth_dvl') == 1 )
    cx = caxis;
    if ( strcmp(location,'puddingstone')  == 1 && cx(2) > 25 )
        caxis([0 25]);
    end
%    load('cm_puddingstone_water_depth.mat')
%    colormap(flipud(cm));
else
    if ( min(data(:,3)) ~= max(data(:,3)) )
        caxis([min(data(:,3)) max(data(:,3))])
    end
end

% spring/summer 2017, adaptive missions
run adpsampl_area_overlay

set(get(cb,'Title'),'String',type_title_string);

% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

focus_map

%% save file
disp(['Save figures for: ' data_type]);
% prefix by date of trial
first_date = data(1,4);
fd_datestr = datestr(first_date);
prefix = fd_datestr(1:strfind(fd_datestr,' ')-1);

% % save jpeg
% save_as_jpeg(data_path_prefix, location, prefix, 'map', data_type, 100);

% save fig
save_as_fig(fig_h, data_path_prefix, location, prefix, 'map', data_type);

end
