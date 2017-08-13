function [] = plot_pitch_roll_from_pfd(filename)

if nargin < 1
  disp('ERROR: please give .pfd filename as argument.')
  return
end

% data directly via importdata, no textdata present in pfd
data = importdata(filename);
rows = size(data,1);
cols = size(data,2);

% visit all rows
pitch = zeros(floor(rows/12),1);
roll = zeros(floor(rows/12),1);
for idx = 1:rows
  if ( data(idx,1) == 0 )
    store = floor(((idx-2)/12)+1);
    % vehicle data. 4: pitch, 5: roll
    pitch(store) = data(idx,4);
    roll(store) = data(idx,5);
  end
end

figure('Position',[0 0 1200 400])
hold on
plot(pitch,'b')
plot(roll,'r')
legend('pitch','roll')
title('EM Pitch & Roll')
ylabel('pitch(deg) and roll(deg)')
xlabel('time(s)')

end