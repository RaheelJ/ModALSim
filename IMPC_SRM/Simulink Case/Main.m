%% Initialization
clear
clc

%% Parameters
G=(1/3)*[2 -1 -1; 0 sqrt(3) -sqrt(3)];
Ts=100e-6;      

%% SynRM
R=2.5;                  %Winding resistance
Lq=0.016;                %Q-axis inductance
Ld=0.04;                 %D-axis inductance
J=0.0755;               %Inertia of rotor
B=0;                    %Damping torque
P=3;                    %Number of poles 
V=220;

%% Initial Conditions
S_init=ones(3, 1);
i_cmd_init=zeros(2, 3);
i_k_init=rand(2, 8);
i_future_init=rand(2, 8);
di_k_init=rand(2, 8);
i_prev_init=rand(2, 1);
r_init=[0; 50; 0];

%% Measurements
% When using with real system replace the blocks in the simulink with real
% measurements
I_output=zeros(3, 1);
% I_output(1)=Ia, I_output(2)=Ib, I_output(3)=Ic 
Sensor_output=zeros(2, 1);
% Sensor_output(1)=speed, Sensor_output(1)=rotor angle 

%% Run simulation.slx