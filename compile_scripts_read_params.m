%% input / preparation
if nargin < 1
  % if no folder specified, ask the user
  data_path_prefix = uigetdir;
end
if nargin < 2
  b_localtime = 1;
end
if nargin < 3
  b_dst = 1;
end
if nargin < 4
  multiple_folders = 0;
end
if nargin < 5
  location = 'puddingstone';
end
disp('Using:')
disp(['data_path_prefix: ' data_path_prefix])
disp(['multiple folders? ' num2str(multiple_folders)])
disp(['location: ' location])
disp(['localtime (bool): ' num2str(b_localtime)])
disp(['DST (bool): ' num2str(b_dst)])

if ( data_path_prefix == 0 )
  error('ERROR: no valid folder specified. Need data_path_prefix.')
end