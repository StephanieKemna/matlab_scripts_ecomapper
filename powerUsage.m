% from VectorMap
% knots = [0.8:0.2:4.0];
% watts = [18, 20, 21, 22, 23, 25, 29, 30, 35, 41, 47, 54, 64, 102, 109, 115, 119];
% source = 'VectorMap';
% from manual
knots = [0.8:0.2:3.4]; % no data beyond, e-mail sent June 19th
watts = [20, 30, 35, 36, 37, 38, 39, 40, 50, 55, 65, 70, 80, 85];
source = 'EcoMapper manual';

figure('Position',[0 0 1400 1200])
plot(knots, watts,'-*k','LineWidth',2);
xlabel('speed (knots)');
ylabel('power usage (Watts)');
title(['EcoMapper Power Usage according to ' source]);
hold on
xlims = get(gca,'XLim');
maxY = 125;
line([1.0 1.0],[0 maxY],'Color',[0 .5 0],'LineStyle','--','LineWidth',2)
line([2.5 2.5],[0 maxY],'Color','red','LineStyle','--','LineWidth',2)
line([2.0 2.0],[0 maxY],'Color','blue','LineStyle','-.','LineWidth',2)
line([4.0 4.0],[0 maxY],'Color','magenta','LineStyle','-.','LineWidth',2)
legend('Power Usage','min speed: 1.0kn','set max speed: 2.5kn','max surface speed: 2.0kn','max underwater speed: 4.0kn','Location','SouthEast');
axis([0 4.5 0 maxY])
% make all text in the figure to size 14
set(gca,'FontSize',16);
set(findall(gcf,'type','text'),'FontSize',16);
grid on;