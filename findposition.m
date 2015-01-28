function numPosition = findposition(device, motor) 
% This function finds the numerical value of the actual position of the
% motor relative to the last zero.  The return is a double, not a string.
%
% The syntax is as follows:
%
% findposition(device, motor)
%
% Device is the declared visa device, and motor is the desired motor or
% axis to be analyzed.
%
% by Andrew Fowler 
% last edit 1 december 2010

try 
    fopen(device);
end

numPosition = str2double(query(device, strcat(num2str(motor), 'TP')));

fclose(device);