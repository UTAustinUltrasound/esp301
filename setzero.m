function v = setzero(device, motor)
% This function allows you to set the current position of a motor to zero.
%
% syntax is as follows:
%
% setzero(device, motor)
%
% Device is the declared visa device, motor is the desired motor or
% axis to be analyzed.
%
% by Andrew Fowler 
% last edit: 7 december 2010

try
    fopen(device);
end

v = zeros(length(motor),1);

for ii = 1:length(motor);
    command = strcat (num2str(motor(ii)), 'DH');
    fprintf(device, command)
    
    v(ii) = str2double(query(device, strcat(num2str(motor(ii)), 'TP')));
    
end

fclose(device);