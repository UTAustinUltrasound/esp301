function v = findvelocity(device, motor)
% Returns motor velocity as a double.
%
% The syntax is as follows:
%
% findvelocity(device, motor)
%
% Device is the declared visa device, and motor is the desired motor or
% axis to be analyzed.
%
% by Andrew Fowler 
% last edit: 3 december 2010

try
    fopen(device);
end

v = str2double(query(device, strcat(num2str(motor), 'VA?')));

fclose(device);