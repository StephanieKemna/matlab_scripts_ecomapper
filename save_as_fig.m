% function [] = save_as_fig(fig_h, data_path_prefix, location, prefix, identifier, data_type)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: June 29, 2017
%
% last tested with MatlabR2018a on Ubuntu 16.04
%
function [] = save_as_fig(fig_h, data_path_prefix, location, prefix, identifier, data_type)

disp('Printing fig...')

% save fig
saveas(fig_h, [data_path_prefix location '_' prefix '_' identifier '_' data_type], 'fig');

end