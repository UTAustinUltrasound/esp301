global ESP
global PosMax
global steps


%% User Defined Variables
PosMax=[1.2, 1.2];  %Maximum distance motor will travel
steps=0.2;          %Step size
y=[0:steps:PosMax(2)]; %motor 2 only moves in one direction for a 2D scenario

xr=[0:steps:PosMax(1)];
xl=fliplr(xr); %motor 1 will move back and forth

% %% Set Parameters
% setvelocity(ESP,1,5)
% c(1)=num2str(findvelocity(ESP,1)) %Motor 1
% c(2)=num2str(findvelocity(ESP,2)) %Motor 2

%% Set current Position to 0
setzero(ESP,1) %Motor 1
setzero(ESP,2) %Motor 2







%% Tester

PosMax=[2, 2];  %Maximum distance motor will travel
steps=0.5;          %Step size
y=[0:steps:PosMax(2)]; %motor 2 only moves in one direction for a 2D scenario

xr=[0:steps:PosMax(1)];
xl=fliplr(xr);

RefMat1=repmat([0:steps:PosMax(1)],[length(xr),1]);
RefMat1(2:2:length(xr),:)=fliplr(RefMat1(2:2:length(xr),:));
RefMat2=repmat([0:steps:PosMax(2)]',[1,length(y)]);
for i=1:length(y)
    pause(0.5);
    for j=1:length(xr)
        pause(0.5);
        if j==length(xr)
            if mod(i,2)==0
                Test(i,j,1)=findposition(ESP,1)*RefMat1(i,j);
                Test(i,j,2)=findposition(ESP,2)*RefMat2(i,j);
            else
                Test(i,j,1)=findposition(ESP,1)*RefMat1(i,j);
                Test(i,j,2)=findposition(ESP,2)*RefMat2(i,j);
            end
        else
            if mod(i,2)==0
                Test(i,j,1)=findposition(ESP,1)*RefMat1(i,j);
                Test(i,j,2)=findposition(ESP,2)*RefMat2(i,j);
                reldisplace(ESP,1,-steps);
            else
                Test(i,j,1)=findposition(ESP,1)*RefMat1(i,j);
                Test(i,j,2)=findposition(ESP,2)*RefMat2(i,j);
                reldisplace(ESP,1,steps);
            end
        end
        j=j+1;
    end
    reldisplace(ESP,2,steps);
    i=i+1;
end
moveto(ESP,1,0); moveto(ESP,2,0);