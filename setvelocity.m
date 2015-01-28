function v = setvelocity(device, motor, velocity)
% This function allows you to set the velocity of the motors for the
% newport device that you're using.  It returns the velocity in set in the
% controller as a double, not a string
%
% syntax is as follows:
%
% setvelocity(device, motor, velocity)
%
% Device is the declared visa device, motor is the desired motor or
% axis to be analyzed, and velocity is the max motor velocity in mm/s.
%
% by Andrew Fowler 
% last edit: 3 december 2010

try
    fopen(device);
end

command = strcat (num2str(motor), 'VA', num2str(velocity));
fprintf(device, command)

v = str2double(query(device, strcat(num2str(motor), 'VA?')));

fclose(device);