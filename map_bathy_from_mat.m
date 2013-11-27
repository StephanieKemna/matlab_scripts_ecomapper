%
% function [] = map_bathy_from_mat(bathy_mat_filename, path_to_map)
%   bathy_mat_filename:
%      name of .mat file where to get bathy data from, default: 'bathy.mat'
%   path_to_map:
%      path to the geo-tiff file, default:
%      '../../Maps/puddingstone/puddingstone_dam_extended.tiff'
%
% nb. data points are cut as per the tiff boundaries.
%
% author: Stephanie Kemna
% institute: University of Southern California
% date: 2013-01-30
%
function [] = map_bathy_from_mat(bathy_mat_filename, path_to_map)
% nb. this uses uncorrect compass information, ie. there will be jumps on
%     surfacing, and thus at-depth reading can be slightly wrong
% version 2: try to interpolate the data

% check args
if ( nargin < 1 )
    bathy_mat_filename = 'bathy.mat';
end
if ( nargin < 2 )
    path_to_map = '../../Maps/puddingstone/puddingstone_dam_extended.tiff';
end

%% load the data
load(bathy_mat_filename)

% load geo-referenced map
[A, R] = geotiffread(path_to_map);

% check the data; exclude points beyond image boundary, so as not to mess
% up the interpolation..
nrPnts = size(data(:,1),1);
idx = 1;
errcnt = 0;
while ( idx < nrPnts )
    remove = 0;
    % detect outliers
    if ( (data(idx,1) < R.Lonlim(1)) || (data(idx,1) > R.Lonlim(2)) )
%         disp( horzcat('lon issue: ', num2str(data(idx,1)), ' min: ', num2str(R.Lonlim(1)), ' max: ', num2str(R.Lonlim(2))) );
        remove = 1;
    elseif ( (data(idx,2) < R.Latlim(1)) || (data(idx,2) > R.Latlim(2)) )
%         disp( horzcat('lat issue: ', num2str(data(idx,2)), ' min: ', num2str(R.Latlim(1)), ' max: ', num2str(R.Latlim(2))) );
        remove = 1;
    end
    % remove from data
    if ( remove )
        % exclude row from data
        [tmp, ps] = removerows(data,'ind',idx);
        data = tmp;
        errcnt = errcnt+1;
        nrPnts = nrPnts-1;
    end
    if ( ~remove )
        idx = idx+1;
    end
end
if ( errcnt > 0 )
    disp(horzcat('Removed ', num2str(errcnt), ' data points outside tiff area'));
end


%% bathymetry plot, AUV path
% prep figure
figure('Position',[0 0 1400 1200])
hold on
% add geo-referenced map
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

minDepth = min(data(:,3));
maxDepth = max(data(:,3));

% plot the bathymetry, for the AUV path
scatter( data(:,1), data(:,2), 10, data(:,3), 'filled' );
colorbar;
caxis([minDepth maxDepth])

% finish figure, TODO: generalize
title('AUV measured depth')
ylabel('latitude')
xlabel('longitude')
% make all text in the figure to size 14 and bold
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16) %,'fontWeight','bold')


%% bathymetry plot, interpolated

% limit interpolation by data range (default), or by image boundaries
% minLon = (R.Lonlim(1)-R.Lonlim(1));
minLon = min(data(:,1));
% maxLon = (R.Lonlim(2)-R.Lonlim(1));
maxLon = max(data(:,1));
% minLat = R.Latlim(1);
minLat = min(data(:,2));
% maxLat = R.Latlim(2);
maxLat = max(data(:,2));

[X, Y] = meshgrid(linspace(minLon,maxLon,100), linspace(minLat,maxLat,100));
zi = griddata(data(:,1), data(:,2), data(:,3), X, Y);

% prep figure
figure('Position',[0 0 1400 1200])
hold on

% add geo-referenced map
[A, R] = geotiffread(path_to_map);
mapshow(A,R);
axis([R.Lonlim(1) R.Lonlim(2) R.Latlim(1) R.Latlim(2)])

% plot interpolated data
scatter(X(:),Y(:),10,zi(:))
colorbar;
caxis([minDepth maxDepth])

% finish figure, TODO: generalize
title('Interpolated bathymetry')
ylabel('latitude')
xlabel('longitude')
% make all text in the figure to size 14 and bold
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16) %,'fontWeight','bold')

end