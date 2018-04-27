%
% function [] = plot_em_by_type(data_type, data_path_prefix, location, b_localtime, b_dst, save_figs)
%   function to plot data from mat file,
%     create mat file from EcoMapper log file using compile_all_ODO.m
%  data_type, options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga
%  default data_path_prefix: '~/data_em/logs/'
%  default location: 'puddingstone
%  b_localtime: convert UTC to local time? (0 or 1, default: 0)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 0)
%  save_figs: whether or not to store a .jpeg and .fig (default: 1)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 22, 2015 - May 2016
%
% tested with MatlabR2018a on Ubuntu 16.04
%
function [] = plot_em_by_type(data_type, data_path_prefix, location, b_localtime, b_dst, save_figs)

%% input/preparation
if nargin < 1
  disp('Error! No data_type defined')
  disp('Options are: odo, chl, water_depth, water_depth_dvl, sp_cond, sal, pH, bga')
  return
end
if nargin < 2
  data_path_prefix = uigetdir('~','Select a folder that contains .log files');
end
if nargin < 3
  location = 'puddingstone';
end
if nargin < 4
  b_localtime = 0;
end
if nargin < 5
  b_dst = 0;
end
if nargin < 6
  save_figs = 1;
end
disp('Using:')
disp(['data_type: ' data_type])
disp(['data_path_prefix: ' data_path_prefix])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])
disp(['save_figs (bool): ' num2str(save_figs)])

% prepare labels
run em_prepare_labels

if ( strcmp(data_path_prefix(end),'/') == 0 )
  data_path_prefix = [data_path_prefix '/'];
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
% loads 'data'

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
scatter(time_datenum, -depth, 30, em_data, 'filled');

% finish figure
c = colorbar;
set(get(c,'Title'),'String',type_title_string);
colormap(jet)

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

xlabel('time (yyyy-mm-dd hh:mm:ss)')
ylabel('depth (m)')
datetick('x','yyyy-mm-dd HH:MM:SS')

% one tick per meter
ax = gca;
yt = get(ax,'YTick');
set(ax,'YTick',min(yt):1:max(yt));
grid on;

h = title(filename(1:end-4));
set(h,'interpreter','none')

grid on

% make all text in the figure to size 16
finish_font

if ( save_figs )
  %% save file
  disp(['Save figures for: ' data_type ' 2D']);
  % prefix by date of trial
  first_date = time_datenum(1);
  fd_datestr = datestr(first_date);
  prefix = fd_datestr(1:strfind(fd_datestr,' ')-1);
  
  % save jpeg
  % save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, 
  %              resolution, postfix, paper_position)
  save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100);
  
  % save fig
  save_as_fig(fig_h, data_path_prefix, location, prefix, 'plot', data_type);
  
  % extra plots caxis chl/bga
  if ( strcmp(data_type,'chl') == 1 && strcmp(location,'puddingstone') == 1 )
    caxis([0 100])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis100');
    
    caxis([0 50])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis50');
  elseif ( strcmp(data_type,'bga') == 1 && strcmp(location,'puddingstone') == 1 )
    caxis([0 30000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis30k');
    
    caxis([0 80000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis80k');

  elseif ( strcmp(data_type,'chl') == 1 && strcmp(location,'elsinore') == 1 )
    disp('Elsinore Chl')

    caxis([0 50])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis50')    

    caxis([0 65])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis65')        
    
  elseif ( strcmp(data_type,'bga') == 1 && strcmp(location,'elsinore') == 1 )
    disp('Elsinore BGA')
    
    caxis([0 100000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis100k')
    
    caxis([0 150000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, 'plot', data_type, 100, 'caxis150k')
  end
  
end

end
