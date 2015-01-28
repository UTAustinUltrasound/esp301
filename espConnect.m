function esp301 = espConnect(comPort)
% This function will automatically connect the esp301 motion controller
% using the virtual serial port (usually COM3), and configuring it
% appropriately.  To my knowledge, the only two parameters of the ESP301
% which are different from matlab defaults are the baudrate and terminator.
%  These are set below.
%
% Andrew Fowler Jan 2015, UT Austin

esp301 = serial(comPort);
set(esp301, 'baudrate', 921600);
set(esp301, 'terminator', 13);
