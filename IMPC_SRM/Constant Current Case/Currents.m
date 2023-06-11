%% Important Points
% 
% * When the parameters of the model are varied such that the system gets
%   slower, then responses will detoriorate unless the sampling time is
%   decreased.
% * When the sampling time of system is decreased, then the responses of 
%   the closed loop system will get better.

%% Constant Currents Case: 
%
% * Due to the motor constraints, the commands should be appropriate for 
%   the system to follow them. 
% * Like given in the paper, the commands should either be equal and 
%   opposite or one of the command should be zero.

%% Initialization
clc
clear
close all

%% Parameters of SynRM
R=2.5;
Lq=0.016;
Ld=0.04;
J=0.755;
T=10;
B=0;
P=3;
V=220; 

%% Sampling Time
Ts=100e-6;
N=100;
Del=Ts/N;
Ns=2000;

%% Calculation of Initial Conditions
init=[0; 0; 0; 0];
i_prev=[0; 0];
First_mode=1;

for i=1:8
    to=Del:Del:Ts;
    tv=to;
    Vabc=Mode(i, V);
    [ty, y]=ode45(@(t, x) SynRM(t, x, Vabc(1), Vabc(2), Vabc(3), tv, R, Lq, Ld, J, T, B, P), to, init);
    iq=y(N, 1);
    id=y(N, 2);
    w=y(N, 3);
    theta=y(N, 4);
    i_k(:, i)=DQ2Clark(theta, id, iq);
    if (i==First_mode)
        temp_init=[iq; id; w; theta];
        tf=ty;
        yf=y;
        iff=i_k(:, i);
        i_measure=iff;
    end
end

di_k=i_k;
init=temp_init;

for i=1:8
    to=Ts+Del:Del:2*Ts;
    tv=to;
    Vabc=Mode(i, V);
    [ty, y]=ode45(@(t, x) SynRM(t, x, Vabc(1), Vabc(2), Vabc(3), tv, R, Lq, Ld, J, T, B, P), to, init);
    iq=y(N, 1);
    id=y(N, 2);
    w=y(N, 3);
    theta=y(N, 4);
    i_future(:, i)=DQ2Clark(theta, id, iq);
end

S=zeros(1, 3);
S(1)=First_mode;
S(2)=First_mode;
S(3)=1;
r=[0; 50];

% %% Pre-defined Initial Conditions:
% %
% % This section is introduced to check the system performance for random
% % initial conditions.
% init=[0; 0; 0; 0];
% i_k=rand(2, 8);
% i_prev=rand(2, 1);
% i_future=rand(2, 8);
% di_k=rand(2, 8);

%% Run of the motor + IMFPC
for xx=1:Ns
    xx
    to=xx*Ts+Del:Del:Ts*(xx+1);

% Read Stator Current:
    i_k(:, S(1))=i_measure;
    temp=i_future;
    
% Apply Conducting Mode:
    Vabc=Mode(S(2), V);
    tv=to;
    [ty, y]=ode45(@(t, x) SynRM(t, x, Vabc(1), Vabc(2), Vabc(3), tv, R, Lq, Ld, J, T, B, P), to, init);
    iq=y(N, 1);
    id=y(N, 2);
    w=y(N, 3);
    theta=y(N, 4);
    i_measure=DQ2Clark(theta, id, iq);
    tf=[tf; ty];
    yf=[yf; y];
    iff=[iff i_measure];
    init=[iq; id; w; theta];

% Compute and Update Current Variations:
    di_prev=di_k;
    di_k(:, S(1))=i_k(:, S(1))-i_prev;

% Generate the Current Command:
    if xx<=2000 
%         i_ref=[5; 0];
        i_ref=[5*sin(2*pi*10*xx*Ts); -5*sin(2*pi*10*xx*Ts)];
    elseif xx<=5000
%         i_ref=[0; -5];
        i_ref=[5*sin(2*pi*10*xx*Ts); -5*sin(2*pi*10*xx*Ts)];
    else
%         i_ref=[-5; 0];
%         i_ref=[5*sin(2*pi*10*xx*Ts); 5*sin(2*pi*10*xx*Ts+pi/2)];
    end
    i_cmd_k=i_ref;
    
% Reset $g_{old}$ and Future Stator Current Prediction:
    for j=1:8
        i_future(:, j)=i_k(:, S(1))+di_k(:, S(2))+di_k(:, j);
        g(j)=sum(abs(i_cmd_k-i_future(:, j)));
    end
    
    [gmin, S(3)]=min(g);
    
% Checking Stagnant Current Mode:  
    r(1)=r(1)+1;
    if r(1)==r(2)
        for l=1:8
            if di_k(:, l)==di_prev(:, l)
                S(3)=l;
            end
        end
        r(1)=0;
    end
    
% Updation of Variables:
    i_prev=i_k(:, S(1));
    i_k=temp;
    S(1)=S(2);
    S(2)=S(3);    
end

%% Calulation of $i_\alpha$ and $i_\beta$
tff=(0:Ns)*Ts;
Stf=size(tf);
ialbe=zeros(2, Stf(1));
for i=1:Stf(1)
    ialbe(:, i)=DQ2Clark(yf(i, 4), yf(i, 2), yf(i, 1));
end
    
%% Plots
figure
plot(tf, ialbe(1, :))
hold on
% plot(tff, i_cmd_k(1), 'r')
grid
xlabel('time (sec)')
ylabel('current (A)')
title('Plot of i_\alpha')

figure
plot(tf, ialbe(2, :))
hold on
% plot(tff, i_cmd_k(2), 'r')
grid
xlabel('time (sec)')
ylabel('current (A)')
title('Plot of i_\beta')

figure
stairs(tf, yf(:, 3))
grid
xlabel('time (sec)')
ylabel('speed (rad/sec)')
title('Plot of \omega_r')

figure
stairs(tf, yf(:, 4))
grid
xlabel('time (sec)')
ylabel('rotor angle (rad)')
title('Plot of \theta_r')

figure
stairs(tf, yf(:, 1))
grid
xlabel('time (sec)')
ylabel('current (A)')
title('Plot of i_q')

figure
stairs(tf, yf(:, 2))
grid
xlabel('time (sec)')
ylabel('current (A)')
title('Plot of i_d')
