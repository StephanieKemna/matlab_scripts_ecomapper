% close all; clear all;

%% prepare
% get functions for loading data
addpath('/home/stephanie/git/matlab-scripts/csvimport/')

% get data
file = '/home/stephanie/data_em/logs/puddingstone_20150501/20150501_200649_lawnmower_westside2_IVER2-135.log';
log_data = csvimport(file,'delimiter',';');
chl_idx = find(strcmp(log_data(1,:),'Chl ug/L'),1);
lon_idx = find(strcmp(log_data(1,:),'Longitude'),1);
lat_idx = find(strcmp(log_data(1,:),'Latitude'),1);
lon = cell2mat(log_data(2:end,lon_idx));
lat = cell2mat(log_data(2:end,lat_idx));
chl = cell2mat(log_data(2:end,chl_idx));

%% create GP
% combine lat/lon data into 2D array
lonlat = [lon, lat];
nrSamp = length(chl);

% kernel width / length scale
kernel_w = diag([0.000237183677861022, 0.00835182525007499].^2);
%     0.00001,0.00001]);

% create the Gram matrix; covariance between training data points
% using squared exponential function
K = zeros(nrSamp);
for i = 1:nrSamp,
    waitbar(i/nrSamp,'train');
    for j = 1:nrSamp,
        K(i,j) = 123.492562185723^2 * exp(-0.5*(lonlat(i,:)-lonlat(j,:))*inv(kernel_w)*(lonlat(i,:)-lonlat(j,:))');
    end
end
% regularization / variance on noise (0.001)
K = K + 21.754300298601^2 * eye(nrSamp);
% prepare inverse
invK = inv(K);

% for our predictions, and visualization, we create a test grid,
% within the space where we sampled1.0
test_pts_per_d = 100;
testX = linspace(min(lon),max(lon),test_pts_per_d);
testY = linspace(min(lat),max(lat),test_pts_per_d);
[testGridX,testGridY] = meshgrid(testX, testY);
% init result vars
testYmu = zeros(test_pts_per_d,test_pts_per_d);
testYsigma = zeros(test_pts_per_d,test_pts_per_d);

% predictive equations
%   calculate covariance between training location and test locations
%   and calculate the mean and variance for the resulting predictive
%   distribution
for i = 1:test_pts_per_d,
    waitbar(i/test_pts_per_d,'test');
    for j = 1:test_pts_per_d,
        k = zeros(size(lonlat,1),1);
        for m = 1:size(lonlat,1),
            % covariance between train and test data pts
            k(m,1) = 123.492562185723^2 * exp(-0.5*([testGridX(i,j) testGridY(i,j)]-lonlat(m,:))*inv(kernel_w)*([testGridX(i,j) testGridY(i,j)]-lonlat(m,:))');
        end
        % covariance between test data pts
        kstar = 123.492562185723^2;
        
        testYmu(i,j) = k'*invK*chl;
        testYsigma(i,j) = sqrt(kstar - k'*invK*k);
    end
end

%% plot

% original data top-down view
figure;
scatter(lon, lat, 20, chl);
colorbar;

% data points
figure;
plot3(lon, lat, chl, '.');
hold on;

% mesh for mean, +- 2 stdev
mesh(testX, testY, testYmu);
mesh(testX, testY, testYmu+2*testYsigma);
mesh(testX, testY, testYmu-2*testYsigma);

set(gca,'FontSize',16);
set(findall(gcf,'type','text'),'FontSize',16);