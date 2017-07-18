sensors_subset = {'odo', 'chl', 'bga', 'temp'};

[filename, Pathname] = uigetfile('*.log', 'Select the data file', ... 
       '/home/jessica/data_em/Logs/puddingstone_20170627/20170627_193227_UTC_0_jessica_mission1_IVER2-135.log');
file_path = strcat(Pathname, filename);

for  element = 1 : length(sensors_subset)
    LogFileDataImport(sensors_subset{element}, file_path)
end 