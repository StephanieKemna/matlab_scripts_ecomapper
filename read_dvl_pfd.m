% usage: read_dvl_pfd(filename,windowSize)
%        reads .dvl and .pfd file for given mission (filename)
%        and produces plots, smoothed for current speed and direction,
%        using the given windowSize
function [] = read_dvl_pfd(filename, windowSize)
    %% want both pfd and dvl file, data
    pfdfile = strcat(filename, '.pfd');
    dvlfile = strcat(filename, '.dvl');

    %% read the data
    % import the data, first row is headers, take only data
    dvl = importdata(dvlfile);
    pfd = importdata(pfdfile);
    
    % check that data field exists in imported dvl data
    if ( isfield(dvl,'data') )
        data = dvl.data;
        rows = size(data,1);

        % for all rows (each has 29 columns)
        Water_Current_Speed = zeros(rows,1);
        WVx = zeros(rows,1);
        WVy = zeros(rows,1);
        Water_Current_Direction = zeros(rows,1);
        depth = zeros(rows,1);
        altitude = zeros(rows,1);
        speedX = zeros(rows,1);
        velocityX = zeros(rows,1);
%         tmp = zeros(rows,1);
        for x = 1:rows 
            %% get the data
            % column indices and naming from DVL Manual
            % importdata puts first 4 columns in textdata
            depth(x) = data(x,(16-4));
            altitude(x) = data(x,(15-4));

            % vehicle data
            C_True_Heading = data(x,(5-4));
            Xspeed = data(x,(9-4));
            Yspeed = data(x,(10-4));
            speedX(x) = Xspeed;
%             tmp(x) = sqrt(Xspeed^2 + Yspeed^2);

            % water velocity
            % data does not have indices 32-43 from doc
            Xvelocity = data(x,(32-4));
            Yvelocity = data(x,(33-4));
            velocityX(x) = -Xvelocity;

            %% calculate the water current, code from DVL Manual
            U = Xvelocity + Xspeed;
            V = Yvelocity + Yspeed;
%            currv = sqrt((V*V)+(U*U));
            currv = sqrt((V^2)+(U^2));
            Water_Current_Speed(x) = currv;

            % Vehicle Compass Heading
            Heading_Deg = 90 - C_True_Heading;
            Heading = Heading_Deg*pi/180;

            % Local angle water velocity, relative to vehicle heading
            Local_Angle = atan2(V,U);
            Local_Angle_Deg = Local_Angle*180/pi; % not used

            % EastingVelocity
            Cx = cos(Heading + Local_Angle) * Water_Current_Speed(x);
            % NorthingVelocity
            Cy = sin(Heading + Local_Angle) * Water_Current_Speed(x);
            
            WVx(x) = Cx;
            WVy(x) = Cy;
            
            % Geographic/compass direction water current
            Current_Direction = atan2(Cy,Cx);
            Water_Current_Direction(x) = 90 - (Current_Direction*180/pi);
        end

        %% display unfiltered data
        figure('Position',[0 0 1200 400])
        plot(Water_Current_Speed)
        % presumably, the current measurement is more accurate when vehicle is
        % at depth
        hold on
        plot(depth, 'r')
        plot(altitude, 'Color', [0 .7 .2])        
        % display up to depth/altitude of 15m
        axis([0 rows 0 15])
        legend('water\_speed (m/s)','em\_depth (m)','em\_altitude (m)')
        title(strcat('Water\_Current\_Speed and EM depth -- ',filename))
        xlabel('time(s)')
        ylabel('current\_speed (m/s) -- em\_depth (m) -- em\_altitude (m)')

        figure('Position',[0 0 1200 400])
        plot(Water_Current_Direction)
        title('Water\_Current\_Direction')
        xlabel('time(s)')
        ylabel('direction(degrees)')
        
%         figure('Position',[0 0 1200 400])
%         plot(tmp)

%         hold off
%         figure()
%         hist(Water_Current_Speed)
%         title('hist(Water\_Current\_Speed)')
%         figure()
%         hist(Water_Current_Direction)
%         title('hist(Water\_Current\_Direction)')
    
        %% try matlab moving average
%         numerator = ones(1,windowSize)/windowSize;
%         denominator = 1;
%         filteredData = filter(numerator,denominator,Water_Current_Speed);

        %% own implementation of a moving average: 
        % y[n] = (1/M) * {sum from -(M-1)/2 to (M-1)/2 of x[n-k]}
%         samples = size(Water_Current_Speed,1);
%         div = floor(windowSize/2);
%         filteredData = zeros(samples,1);
%         for idx = 1:samples
%            windowSum = 0;
%            minSample = idx-div;
%            maxSample = idx+div;
%            if ( minSample < 1 )
%                minSample = 1;
%            end
%            if ( maxSample > samples )
%                maxSample = samples;
%            end
%            for idM = minSample:maxSample
%                windowSum = windowSum + Water_Current_Speed(idM);
%            end
%            % iterate over all samples
%            filteredData(idx) = (1/windowSize) * windowSum;
%         end

        %% try matlab's smoothing function
        filteredSpeed = smooth(Water_Current_Speed,windowSize);

        figure('Position',[0 0 1200 400])
        plot(filteredSpeed)
        xlabel('time(s)')
        ylabel('current\_speed (m/s)')
        title(strcat('Water\_Current\_Speed, smoothed with span: ',num2str(windowSize)))
        figure()
        hist(filteredSpeed)
        title('hist(Running average of Water\_Current\_Speed)')
        
        filteredDirection = smooth(Water_Current_Direction,windowSize);
        figure('Position',[0 0 1200 400])
        plot(filteredDirection)
        xlabel('time(s)')
        ylabel('current\_direction (m/s)')
        title(strcat('Water\_Current\_Direction, smoothed with span: ',num2str(windowSize)))
        figure()
        hist(filteredDirection)
        title('hist(Running average of Water\_Current\_Direction)')
        
        %% test Arvind
        figure()
        plot(speedX);
        hold on
        plot(velocityX, 'r');
        plot(Water_Current_Speed,'c')
        plot(filteredSpeed, 'g');
        plot(WVx, 'm');
        plot(WVy, 'y');
        legend('vehicle V_X', 'water V_X', 'unfiltered current speed','filtered current speed', 'WVx','WVy');
        xlabel('time(s)')
        ylabel('speed (m/s)')
        
        figure()
        title('Northing, Easting velocities')
        plot(WVx, 'm');
        hold on;
        plot(WVy, 'y');
        plot(smooth(WVx,windowSize),'c');
        plot(smooth(WVy,windowSize),'g');
        plot(Water_Current_Speed,'k');
        plot(filteredSpeed,'b');
        legend('WVx','WVy','smoothWVx','smoothWVy','Water_Current_Speed','filteredSpeed');
    else
        disp(strcat('No data in file: ',filename))
    end
    
end
