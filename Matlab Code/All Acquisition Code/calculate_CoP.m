function [Platform_data, labels] = calculate_CoP (data)

%[Platform_data] = calculate_CoP (data)
%
%calculates forces, moments and CoP coordinates from the raw data acquired
%by a single force plate
%
%INPUTS:
%
%data: a matrix containing the raw data acquired from the force plate. This
%matrix contains 8 channels organized in the following order: Fx12, Fx34,
%Fy14, Fy23, Fz4, Fz3, Fz2, Fz1
%
%OUTPUTS:
%
%Platform_data: a matrix containing the platform processed data in the
%following order: Fx, Fy, Fz, Mx, My, Mz, CoPx, CoPy
%labels: contains the labels of the 8 output channels



Fx12 = data(:,1);
Fx34 = data(:,2);
Fy14 = data(:,3);
Fy23 = data(:,4);
Fz4 = data(:,5);
Fz3 = data(:,6);
Fz2 = data(:,7);
Fz1 = data(:,8);

m_PlateA   =  0.164;    % [m]
m_PlateB   =  0.264;    % [m]


m_PlateZdX = 0.0225;   % [m]
m_PlateZdY = 0.0225;   % [m]

Fx = Fx12 + Fx34;
Fy = Fy14 + Fy23;
Fz = Fz1 + Fz2 + Fz3 + Fz4;
Mx = m_PlateB * ( Fz1 + Fz2 - Fz3 - Fz4 );
My = m_PlateA * ( -Fz1 + Fz2 + Fz3 - Fz4 );
Mz = m_PlateB * ( -Fx12 + Fx34 ) + m_PlateA * (Fy14 - Fy23);

Mya = My - Fx.*m_PlateZdY;
Mxa = Mx + Fy.*m_PlateZdX;

CoPx = -Mya./Fz;
CoPy = Mxa./Fz;

Platform_data = [Fx, Fy, Fz, Mx, My, Mz, CoPx, CoPy];
labels = {'Fx','Fy','Fz','Mx','My','Mz','CoPx','CoPy'};


