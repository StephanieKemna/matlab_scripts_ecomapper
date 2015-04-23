%
% function [] = map_puddingstone_depth_interpolated (data_type, mapfile, data_path_prefix, location)
% Plot an interpolated grid of the bathymetry data measured by the
% EcoMapper
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
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
% tested with MatlabR2012a on Ubuntu 14.04
%
function [] = map_data_from_ecomapper_by_type (data_type, mapfile, data_path_prefix, location)

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

filename = [data_path_prefix data_type '_' location '.mat'];

% create data file if necessary
if ~exist(filename,'file')
    disp('data file non-existent, calling compile_all_by_type');
    compile_all_by_type(data_type, data_path_prefix, location)
end

% prepare labels
if (strcmp(data_type,'odo') == 1)
    type_string = 'ODO mg/L';
    type_title_string = 'Dissolved Oxygen (mg/L)';
elseif (strcmp(data_type,'chl') == 1)
    type_string = 'Chl ug/L';
    type_title_string = 'Chlorophyll (ug/L)';
elseif (strcmp(data_type,'water_depth') == 1)
    type_string = 'Total Water Column (m)';
    type_title_string = 'Water Depth (m)';
elseif (strcmp(data_type,'water_depth_dvl') == 1)
    type_string = 'DVL -Water Column (m)';
    type_title_string = 'Water Depth from DVL (m)';
elseif (strcmp(data_type,'sp_cond') == 1)
    type_string = 'SpCond mS/cm';
    type_title_string = 'Conductivity mS/cm';
elseif (strcmp(data_type,'sal') == 1)
    type_string = 'Sal ppt';
    type_title_string = 'Salinity (ppt)';
elseif (strcmp(data_type,'pH') == 1)
    type_string = 'pH'; % note, this is not mV
    type_title_string = 'pH';
elseif (strcmp(data_type,'turb') == 1)
    type_string = 'Turbid+ NTU';
    type_title_string = 'Turbidity (NTU)';
elseif (strcmp(data_type,'bga') == 1)
    type_string = 'BGA-PC cells/mL';
    type_title_string = 'Blue-Green Algae (cells/mL)';
else
    disp('Unknown data type. Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
    return
end

%% prepare figure
figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map as background
[A, R] = geotiffread(mapfile);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

%% load data
load(filename);

%% plot bathy colors
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled');

%% finish figure
title([location ' EM measured ' type_title_string])
ylabel('latitude')
xlabel('longitude')
cb = colorbar;
minDepth = min(data(:,3));
maxDepth = max(data(:,3));
caxis([minDepth maxDepth]);
set(get(cb,'Title'),'String','Depth (m)');
% make all text in the figure to size 16
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)

end
