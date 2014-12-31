%
% function [] = plot_em_odo(matfilename)
%   function to plot data from mat file, 
%     create mat file from EcoMapper log file using compile_all_ODO.m
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: Dec 29, 2014
%
function [] = plot_em_odo(matfilename)

% load the data
load(matfilename);

% extract data into logical names
longitude = data(:,1);
latitude = data(:,2);
dis_ox = data(:,3);
time_datenum = data(:,4);
depth = data(:,5);

% prep figure
figure('Position',[0 0 2000 1200])
hold on
    
% plot the data, colored by level of dissolved oxygen
scatter(time_datenum, -depth, 30, dis_ox, 'filled');

% finish figure
c = colorbar;
set(get(c,'Title'),'String','ODO (mg/L)');
caxis([0 20])
load('odo-cm.mat')
colormap(cm)

xlabel('time (yymmdd)')
ylabel('depth (m)')
datetick('x','yymmddHHMMSS')

h = title(matfilename(1:end-4));
set(h,'interpreter','none')

set(gca,'FontSize',16);
set(findall(gcf,'type','text'),'FontSize',16);

end
