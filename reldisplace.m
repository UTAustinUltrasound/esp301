function position = reldisplace(device, motor, distance)
% This function sends the PR command to any newport motor controller with a
% GPIB interface.  The device must be declared, and the distance is in
% millimeters out to three decimals. Note that this function returns the 
% final position of the motor after displacement as a double.
%
% syntax is as follows:
%
% reldisplace(device, motor, distance)
%
% % Where device is the declared visa device, motor is the desired motor, and
% distance is the distance from the current zero position in millimeters to
% 3 decimal points.  Note that the final position value of this command has
% an error of +/- 0.050.
%
% By Andrew Fowler 
% last edit: 3 december 2010

try
    fopen(device)           % Tries to open the device if it's closed
end

% The motor and distance variables must be converted to strings and
% concatenated before it's sent to the controller
movecommand = strcat(num2str(motor),'PR',num2str(distance));
wait4stop = strcat(num2str(motor),'WS');
wait4jerk = strcat(num2str(motor),'WT.5');
positionquery= strcat(num2str(motor),'TP?');

% Concantenate and send to the controller
command = strcat(movecommand, ';', wait4stop, ';', wait4jerk, ';', positionquery);
fprintf(device, command);

%find the position
position = str2double(fscanf(device));

fclose(device);