%% input / preparation
if ~exist('data_path_prefix','var')
  % if no folder specified, ask the user
  data_path_prefix = uigetdir('~','Select a folder that contains .log files');
end
if ~exist('b_localtime','var')
  b_localtime = 1;
end
if ~exist('b_dst','var')
  b_dst = 1;
end
if ~exist('multiple_folders','var')
  multiple_folders = 0;
end
if ~exist('location','var')
  location = 'puddingstone';
end
% report settings
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['multiple folders? ' num2str(multiple_folders)])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])

if ( data_path_prefix == 0 )
  error('ERROR: no valid folder specified. Need data_path_prefix.')
end