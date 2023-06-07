clear
clc
close all

%Plant
Ap=[0 100*pi; -0.05 -0.01];
Bp=[0; 0.1];
Cp=[1 0];
Dp=0;
Ps=ss(Ap, Bp, Cp, Dp);
P=tf(Ps)

%We
Me=1.2;             %Peak of 1/We
ee=0.2;
wbe=5;              %Cutoff frequency
num=[1/Me wbe];
den=[1 wbe*ee];
We=tf(num, den)

%Wu
r1=1;               %Comparative weighting 
Mu=1.2;             %Peak of 1/Wu
eu=0.05;
wbu=12;             %Cutoff frequency
num=r1*[1 wbu/Mu];
den=[eu wbu];
Wu=tf(num, den)

%Wt
r2=1;               %Comparative Weighting
Mt=1.2;             %Peak of 1/Wt
et=0.2;
wbt=100;             %Cutoff frequency
num=r2*[1 wbt/Mt];
den=[et wbt];
Wt=tf(num, den)

%G
Gt=[We -We -We -We*P;
    0    0   0    Wu;
    0   Wt   0  Wt*P
    1  -1   -1     P];

G=ss(Gt);
G=minreal(G)

[K, Tzw, ro]=hinfsyn(G, 1, 1, 0, 10, 0.0001);
K=tf(K)

%Sensitivity functions
S=1/(1+K*P);
T=1-S;
KS=K*S;
w1=-2;
w2=4;
w=logspace(w1, w2, 1000);

%Weighting functions plot
figure
bodemag(1/We, 1/Wt, 1/Wu, w);
grid

%Sensitivity functions plot
figure
subplot(2, 2, 1)
bodemag(S, 1/We, w);
grid
subplot(2, 2, 2)
bodemag(KS, 1/Wu, w);
grid
subplot(2, 2, 3)
bodemag(T, 1/Wt, w);
grid

%Weight For Reference Input
Wr=1/0.229;         %To remove steady state error
subplot(2, 2, 4)
step(T);
title('Step reference response of closed loop system')
grid

%Weighting Sensitivity functions plot
figure
bodemag(We*S, Wu*KS, Wt*T, w);
grid

%e and u for step input r
figure
step(We*S, Wu*KS);
grid
title('Error and Plant Input Signal for Step Reference')


