% area, 300x200m, @450
lo_w = -117.810209011259;
lo_e = -117.806958289882;
la_s = 34.0874501434325;
la_n = 34.0892531798889;

% % area, 400x200m, @500
% lo_w = -117.809667078311;
% lo_e = -117.805332783142;
% la_s = 34.0874537159634;
% la_n = 34.0892567524198;

line([lo_w lo_e],[la_s la_s],'Color',[1 1 1],'LineWidth',3)
line([lo_w lo_w],[la_s la_n],'Color',[1 1 1],'LineWidth',3)
line([lo_w lo_e],[la_n la_n],'Color',[1 1 1],'LineWidth',3)
line([lo_e lo_e],[la_n la_s],'Color',[1 1 1],'LineWidth',3)

% focus on area
run focus_puddingstone
