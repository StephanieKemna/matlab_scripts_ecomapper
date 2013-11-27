function [] = map_puddingstone_depth ()
% nb. this uses uncorrect compass information, ie. there will be jumps on
%     surfacing, and thus at-depth reading can be slightly wrong
% version 2: try to interpolate the data

figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map of Puddingstone
[A, R] = geotiffread('../../Maps/puddingstone/puddingstone_dam_extended.tiff');
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])
 
%% read the data (need only be done once)
% cnt = 0;
% pudd = dir('../../deployments/puddingstone_*');
% for idx = 1:size(pudd,1)
%     logfiles = dir(fullfile('../../deployments/',pudd(idx).name,'logs/*.log'));
%     for idy = 1:size(logfiles,1)
%         disp(strcat('adding: ',logfiles(idy).name))
%         log = importdata(fullfile('../../deployments/',pudd(idx).name,'logs/',logfiles(idy).name),';');
%         if ( isfield(log,'textdata') )
%             % textdata col 1: latitude, col 2: longitude, col 17: total water column
%             lat = log.textdata(:,1);
%             latitude = str2double(lat(2:size(lat,1)));
%             lon = log.textdata(:,2);
%             longitude = str2double(lon(2:size(lon,1)));
%             depth = log.textdata(:,17);
%             lake_depth = str2double(depth(2:size(depth,1)));
%             
%             for ( dat = 1:size(latitude,1) )
%                 if ( lake_depth < 999 ) % filter out erroneous data
%                     cnt = cnt+1;
%                     data(cnt,:) = [longitude(dat) latitude(dat) lake_depth(dat)];
%                 end
%             end
%         end
%     end
% end
% max(data(:,3))
% disp(strcat('processed ',num2str(cnt),' data pnts'));
% 
% save('bathy.mat', 'data');
load('bathy.mat')

minDepth = min(data(:,3));
maxDepth = max(data(:,3));

% plot the bathymetry
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled' );
colorbar;
caxis([minDepth maxDepth])

%% finish figure
title('Puddingstone EM measured lake depth')
ylabel('latitude')
xlabel('longitude')
% make all text in the figure to size 14 and bold
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16) %,'fontWeight','bold')


%% interpolation
% longrid = (R.Lonlim(1)-R.Lonlim(1)):0.0001:(R.Lonlim(2)-R.Lonlim(1));
% latgrid = R.Latlim(1):0.0001:R.Latlim(2);
% minLon = (R.Lonlim(1)-R.Lonlim(1));
minLon = min(data(:,1))
% maxLon = (R.Lonlim(2)-R.Lonlim(1));
maxLon = max(data(:,1))
% minLat = R.Latlim(1);
minLat = min(data(:,2))
% maxLat = R.Latlim(2);
maxLat = max(data(:,2))
[X, Y] = meshgrid(linspace(minLon,maxLon,100), linspace(minLat,maxLat,100));
% [X, Y] = meshgrid(data(:,1),data(:,2))

zi = griddata(data(:,1), data(:,2), data(:,3), X, Y);
% zi = interp2(data(:,1), data(:,2), data(:,3), X, Y);
% zi = interp2(X, Y, data(:,3), data(:,1), data(:,2));
% scatter(X(:),Y(:),10,zi(:))

%% figure interpolated data
figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map of Puddingstone
[A, R] = geotiffread('../../Maps/puddingstone/puddingstone_dam_extended.tiff');
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

scatter(X(:),Y(:),10,zi(:))
colorbar;
caxis([minDepth maxDepth])

% finish figure
title('Puddingstone interpolated bathymetry')
ylabel('latitude')
xlabel('longitude')
% make all text in the figure to size 14 and bold
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16) %,'fontWeight','bold')

end