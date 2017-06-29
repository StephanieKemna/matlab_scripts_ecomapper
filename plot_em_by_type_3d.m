%
% function [] = plot_em_by_type_3e(location, b_localtime, b_dst)
%   function to plot data from mat file, 
%     create mat file from EcoMapper log file using compile_all.m
%  default location: 'puddingstone
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%
% Author: Stephanie Kemna, Jessica Gonzalez
% Institution: University of Southern California
% Date: Apr 22, 2015 - May 2016 - June 2017
%
function [] = plot_em_by_type_3d( location, b_localtime, b_dst)

%% input/preparation
if nargin < 1
    location = 'puddingstone';
end
if nargin < 2
    b_localtime = 0;
end
if nargin < 3
    b_dst = 0;
end

% interactive choice of data dir
data_path_prefix = uigetdir 

% interactive choice of data type
data_types = {'odo', 'chl', 'water_depth', 'water_depth_dvl', 'sp_cond', 'sal', 'ph', 'bga', 'temp', 'temp2'};
[choice,ok]= listdlg('PromptString', 'Select a file:','SelectionMode', 'single','ListString', data_types)
data_type = data_types{choice}

% prepare labels
run em_prepare_labels

if ( strcmp(data_path_prefix(end),'/') == 0 )
    data_path_prefix = [data_path_prefix '/']
end

%% read data
% load the data
filename = [data_path_prefix data_type '_' location '.mat']
% create data file if necessary
if ~exist(filename,'file')
    disp('data file non-existent, calling compile_all_by_type');
    compile_all_by_type(data_type, data_path_prefix, 0, location, b_localtime, b_dst)
end
if ~exist(filename,'file')
    disp('data file still non-existent, not plotting');
    return;
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
fig_h = figure('Position',[0 0 2000 1200]);
hold on
    
% plot the data, colored by level of dissolved oxygen
scatter3(longitude,latitude,-depth,20,em_data,'filled')
view(3)

% finish figure
c = colorbar;
set(get(c,'Title'),'String',type_title_string);
if ( strcmp(data_type,'odo') == 1)
    caxis([0 20])
    load('odo-cm.mat')
    colormap(cm)
elseif ( strcmp(data_type,'water_depth') == 1 || strcmp(data_type,'water_depth_dvl') == 1 )
    if ( strcmp(location,'puddingstone') == 1 )
        cx = caxis;
        if ( cx(2) > 25 )
            caxis([0 25])
        end
    end
end

zlabel('Depth')
ylabel('Latitude')
xlabel('Longitude')

grid on;

h = title(filename(1:end-4));
set(h,'interpreter','none')

% make all text in the figure to size 16
set(gca,'FontSize',16);
set(findall(gcf,'type','text'),'FontSize',16);

% %% save file
% disp(['Save figures for: ' data_type]);
% % prefix by date of trial
% first_date = time_datenum(1);
% fd_datestr = datestr(first_date);
% prefix = fd_datestr(1:strfind(fd_datestr,' ')-1);
% 
% % save jpeg
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 12])
% print('-djpeg','-r100',[data_path_prefix location '_' prefix '_plot_' data_type])
% 
% % save fig
% saveas(fig_h, [data_path_prefix location '_' prefix '_plot_' data_type], 'fig');

end
