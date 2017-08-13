% function [] = save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, resolution, postfix, paper_position)
%
% Author: Stephanie Kemna
% Institution: University of Southern California
% Date: June 29, 2017
%
% tested with MatlabR2012a on Ubuntu 16.04
%
function [] = save_as_jpeg(data_path_prefix, location, prefix, identifier, data_type, resolution, postfix, paper_position)

% process parameters
res_str = ['-r' num2str(resolution)];
if nargin < 8
  paper_position = [0 0 20 12];
end

disp('Printing jpeg...')

% save jpeg
set(gcf,'PaperUnits','inches','PaperPosition',paper_position)

% construct filename
if ( exist('postfix','var') == 1 )
  filenm = [data_path_prefix location '_' prefix '_' identifier '_' data_type '_' postfix];
else
  filenm = [data_path_prefix location '_' prefix '_' identifier '_' data_type];
end

% choose renderer depending on whether or not it is a 3d plot
if ( strfind(identifier,'3d') > 0 )
  print('-djpeg',res_str,filenm,'-zbuffer')
else
  print('-djpeg',res_str,filenm,'-painters')
end
  
end