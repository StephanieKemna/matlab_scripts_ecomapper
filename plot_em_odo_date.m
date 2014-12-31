%
% function [] = plot_em_odo(matfilename, dd, mm, yyyy)
%   function to plot data from mat file, 
%     create mat file from EcoMapper log file using compile_all_ODO.m
%   choosing a specific date (specify via dd, mm, yyyy)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Dec 29, 2014
%
function [] = plot_em_odo_date(matfilename, dd, mm, yyyy)

% load the data
load(matfilename);

% extract data into logical names
longitude = data(:,1);
latitude = data(:,2);
dis_ox = data(:,3);
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
        nw_odo(cnt) = dis_ox(dep_idx);
        nw_time(cnt) = time_datenum(dep_idx);
    end
end

if ( cnt > 0 )
    min_ODO = min(nw_odo)
    max_ODO = max(nw_odo)
    
    % prep figure
    figure('Position',[0 0 2000 1200])
    hold on

    % plot the data, colored by level of dissolved oxygen
    scatter(nw_time, -nw_depth, 30, nw_odo, 'filled');

    % finish figure
    c = colorbar;
    set(get(c,'Title'),'String','ODO (mg/L)');
    caxis([0 20])
    load('odo-cm.mat')
    colormap(cm)

    xlabel('time (yymmdd)')
    ylabel('depth (m)')
    datetick('x','HH:MM:SS')

    h = title(['EM ODO vs depth and time for: ' date_desired]);
    set(h,'interpreter','none')

    set(gca,'FontSize',16);
    set(findall(gcf,'type','text'),'FontSize',16);
end

end
