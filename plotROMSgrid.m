%% get data
load('../../../../fcst_20120901_0.mat')
path_to_map = '../../Maps/scb/SCB.tiff';

% get map
[A, R] = geotiffread(path_to_map);

% get data
adjusted_lon = temp_forecast.lon(:)-360;
[X,Y]=meshgrid(temp_forecast.lat,adjusted_lon);
U=temp_forecast.u.u; V=temp_forecast.v.v;
U(find(U<-10))=nan; V(find(V<-10))=nan;

%% plot
% map
figure('Position',[0 0 1200 600])
mapshow(A,R);
axis([-118.0747 -117.93063 33.565949 33.635574])
hold on

% current predictions / ROMS points
quiver(Y,X,U(:,:,1)',V(:,:,1)','Color',[1 1 0], 'LineWidth', 2)

% ESPs
% 33° 35' 02.1"
% 118° 2' 05.7"
plot(-118.034917,33.583917,'*','Color',[1 1 1])
text(-118.034,33.583917,'ESP1','Color',[1 1 1])
% 33° 36' 19.8"
% 118° 01' 08.7"
plot(-118.019083,33.605500,'*','Color',[1 1 1])
text(-118.018,33.605500,'ESP2','Color',[1 1 1])

%% finish figure
% increase font size
set(gca,'FontSize',16)
set(findall(gcf,'type','text'),'FontSize',16)
title('ROMS grid points around EcoHab ESP locations')
xlabel('longitude')
ylabel('latitude')