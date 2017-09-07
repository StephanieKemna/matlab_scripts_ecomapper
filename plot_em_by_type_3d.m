%
% function [] = plot_em_by_type_3d(data_type, data_path_prefix, location, b_localtime, b_dst, save_figs)
%   function to plot data from mat file,
%     create mat file from EcoMapper log file using compile_all.m
%  dialog windows will show for data_type and data_path_prefix if not
%  specified
%  default location: 'puddingstone'
%  b_localtime: convert UTC to local time? (0 or 1, default: 1)
%  b_dst: use Daylight Savings Time (if b_localtime)? (0 or 1, default: 1)
%  save_figs: store as fig and jpg (0 or 1, default: 1)
%
% Author: Stephanie Kemna, Jessica Gonzalez
% Institution: University of Southern California
% Date: Apr 22, 2015 - May 2016 - June 2017
%
% tested with MatlabR2012a on Ubuntu 16.04
%
function [] = plot_em_by_type_3d(data_type, data_path_prefix, location, b_localtime, b_dst, save_figs)

%% input/preparation
if nargin < 1
  % interactive choice of data type, if none given
  data_types = {'odo', 'chl', 'water_depth', 'water_depth_dvl', 'sp_cond', 'sal', 'ph', 'bga', 'temp', 'temp2'};
  [choice,ok] = listdlg('PromptString', 'Select a file:','SelectionMode', 'single','ListString', data_types);
  data_type = data_types{choice};
end
if nargin < 2
  % interactive choice of data dir, if none given
  data_path_prefix = uigetdir;
end
if nargin < 3
  location = 'puddingstone';
end
if nargin < 4
  b_localtime = 1;
end
if nargin < 5
  b_dst = 1;
end
if nargin < 6
  save_figs = 1;
end

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
fig_h = figure('Position',[0 0 1600 1200]);
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

% change viewing angle slightly to be a bit more based on Lon axis
view([-30.0 25])
if ( strcmp(location,'elsinore') == 1 )
  view([-6 14])
end

%% save file
if ( save_figs )
  disp(['Save figures for: ' data_type '3D']);
  % prefix by date of trial
  first_date = time_datenum(1);
  fd_datestr = datestr(first_date);
  prefix = fd_datestr(1:strfind(fd_datestr,' ')-1);
  
  % save jpeg
  save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, [0 0 16 12])
  
  % save fig
  save_as_fig(fig_h, data_path_prefix, location, prefix, '3dplot', data_type);
  
  % extra plots caxis chl/bga
  if ( strcmp(data_type,'chl') == 1 && strcmp(location,'puddingstone') == 1 )
    caxis([0 100])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis100', [0 0 16 12])
    
    caxis([0 50])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis50', [0 0 16 12])
  elseif ( strcmp(data_type,'bga') == 1 && strcmp(location,'puddingstone') == 1 )
    caxis([0 30000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis30k', [0 0 16 12])
    
    caxis([0 80000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis80k', [0 0 16 12])
  elseif ( strcmp(data_type,'chl') == 1 && strcmp(location,'elsinore') == 1 )
    disp('Elsinore Chl')

    caxis([0 50])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis50', [0 0 16 12])    

    caxis([0 65])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis65', [0 0 16 12])        
    
  elseif ( strcmp(data_type,'bga') == 1 && strcmp(location,'elsinore') == 1 )
    disp('Elsinore BGA')
    
    caxis([0 100000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis100k', [0 0 16 12])
    
    caxis([0 150000])
    % save jpeg
    save_as_jpeg(data_path_prefix, location, prefix, '3dplot', data_type, 70, 'caxis150k', [0 0 16 12])
  end
  
end

end
