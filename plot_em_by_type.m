%
% function [] = plot_em_by_type(data_type,data_path_prefix, location)
%   function to plot data from mat file, 
%     create mat file from EcoMapper log file using compile_all_ODO.m
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015
%
function [] = plot_em_by_type(data_type,data_path_prefix, location)

%% input/preparation
if nargin < 1
    disp('Error! No data_type defined')
    disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
    return
end
if nargin < 2
    data_path_prefix = '~/data_em/logs/';
    location = 'puddingstone';
end

% prepare labels
run em_prepare_labels

%% read data
% load the data
filename = [data_path_prefix data_type '_' location '.mat'];
% create data file if necessary
if ~exist(filename,'file')
    disp('data file non-existent, calling compile_all_by_type');
    compile_all_by_type(data_type, data_path_prefix, location)
end

load(filename);

% extract data into logical names
% we utilize the fact that our compile script stores the relevant data
% in the third column
longitude = data(:,1);
latitude = data(:,2);
em_data = data(:,3);
time_datenum = data(:,4);
depth = data(:,5);

%% plot
% prep figure
figure('Position',[0 0 2000 1200])
hold on
    
% plot the data, colored by level of dissolved oxygen
scatter(time_datenum, -depth, 30, em_data, 'filled');

% finish figure
c = colorbar;
set(get(c,'Title'),'String','ODO (mg/L)');
caxis([0 20])
load('odo-cm.mat')
colormap(cm)

xlabel('time (yymmdd)')
ylabel('depth (m)')
datetick('x','yymmddHHMMSS')

h = title(filename(1:end-4));
set(h,'interpreter','none')

set(gca,'FontSize',16);
set(findall(gcf,'type','text'),'FontSize',16);

end
