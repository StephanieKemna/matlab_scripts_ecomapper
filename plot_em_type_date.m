%
% function [] = plot_em_type_date(matfilename, dd, mm, yyyy, type)
%   function to plot data from mat file, 
%     create mat file from EcoMapper log file using compile_all_type.m
%   choosing a specific date (specify via dd, mm, yyyy)
%   default type: 'odo'
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Apr 20, 2015
%
function [] = plot_em_type_date(matfilename, dd, mm, yyyy, type)

if nargin < 5
    type = 'odo'
end

% load the data
load(matfilename);

% extract data into logical names
longitude = data(:,1);
latitude = data(:,2);
desired_data = data(:,3);
time_datenum = data(:,4);
depth = data(:,5);

% construct desired date
date_desired = datestr([num2str(mm) '-' num2str(dd) '-' num2str(yyyy)])

cnt = 0;
for ( dep_idx = 1:length(depth) )
    % compare the date
    if ( strncmp(date_desired, datestr(time_datenum(dep_idx)), 11) )
        cnt = cnt + 1;
        nw_depth(cnt) = depth(dep_idx);
        nw_data(cnt) = desired_data(dep_idx);
        nw_time(cnt) = time_datenum(dep_idx);
    end
end

if ( cnt > 0 )
    min_desired_data = min(nw_data)
    min_desired_data = max(nw_data)
    
    % prep figure
    figure('Position',[0 0 2000 1200])
    hold on

    % plot the data, colored by level of dissolved oxygen
    scatter(nw_time, -nw_depth, 30, nw_data, 'filled');

    % finish figure
    c = colorbar;

    if ( type == 'odo')
        set(get(c,'Title'),'String','ODO (mg/L)');
        caxis([0 20]);
        load('odo-cm.mat');
        colormap(cm)
    elseif ( type == 'chl' )
        set(get(c,'Title'),'String','Chl (ug/L)');
    end

    xlabel('time (yymmdd)')
    ylabel('depth (m)')
    datetick('x','HH:MM:SS')

    h = title(['EM ' type ' vs depth and time for: ' date_desired]);
    set(h,'interpreter','none')

    set(gca,'FontSize',16);
    set(findall(gcf,'type','text'),'FontSize',16);
end

end
