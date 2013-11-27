function [] = map_puddingstone_depth ()
% nb. this uses uncorrect compass information, ie. there will be jumps on
%     surfacing, and thus at-depth reading can be slightly wrong

figure('Position',[0 0 1400 1200])
hold on
title('Puddingstone lake depth')
ylabel('latitude')
xlabel('longitude')

[A, R] = geotiffread('../../Maps/puddingstone/puddingstone_dam_extended.tiff');
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

% make all text in the figure to size 14 and bold
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16) %,'fontWeight','bold')

pudd = dir('../../deployments/puddingstone_*');
for idx = 1:size(pudd,1)
    
    logfiles = dir(fullfile('../../deployments/',pudd(idx).name,'logs/*.log'));
    for idy = 1:size(logfiles,1)
        disp(strcat('adding: ',logfiles(idy).name))
        log = importdata(fullfile('../../deployments/',pudd(idx).name,'logs/',logfiles(idy).name),';');
        if ( isfield(log,'textdata') )
            % textdata col 1: latitude, col 2: longitude, col 17: total water column
            lat = log.textdata(:,1);
            lon = log.textdata(:,2);
            lake_depth = log.textdata(:,17);

            scatter( str2double(lon(2:size(lon,1))), str2double(lat(2:size(lat,1))), 10, str2double(lake_depth(2:size(lake_depth,1))), 'filled');
        end
    end
end

colorbar;
% limit the scale to ignore 999 values.
caxis([0 25]);

end