% usage: reads given folder, processes all .dvl and .pfd files, calls
% test_read_dvl and plot_pitch_roll_from_pfd
function [] = test_read_folder(folder)

    basedir = '/home/stephanie/Desktop';

    % go to the given folder
    cd(folder);
    % keep functions accessible
    addpath(basedir);
    
    % process all .dvl files
    dvlfiles = dir('*.dvl');
    for idx = 1:size(dvlfiles,1)
        name = dvlfiles(idx).name;
        test_read_dvl(name);
    end
    
    % process all .pfd files
    pfdfiles = dir('*.pfd');
    for idx = 1:size(pfdfiles,1)
        name = pfdfiles(idx).name;
        plot_pitch_roll_from_pfd(name);
    end
    
    % return to start location
    cd(basedir)
end