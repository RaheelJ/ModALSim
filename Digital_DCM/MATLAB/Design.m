clear
clc

%Open Loop System
A=[0 1; 0 -3.3917];
B=[0; 13.2593];
C=[1 0];
D=0;
G_c=ss(A, B, C, D);
[num, den]=ss2tf(A, B, C, D);
G=tf(num, den);

%Discretization
T=0.06;
[G_d H]=c2d(G_c, T, 'ZOH');

%Controller Specifications
MO=0.2;         
Ts=1;

%Dominant Closed Loop Poles of Unity Feedback System (s-domain)
zeta=(abs(log(MO)))/(sqrt(pi^2+(log(MO)^2)));
wn=3/(zeta*Ts);
xtic_eqn=[1 2*zeta*wn wn^2];
d_poles=roots(xtic_eqn)';
a = real(d_poles(1));
b = abs(imag(d_poles(1)));

%Desired Closed Loop Poles (z-domain)
pol_1=exp(a*T)*(cos(b*T)+1j*sin(b*T));
pol_2=exp(a*T)*(cos(b*T)-1j*sin(b*T));
c_pol=[pol_1 pol_2];

%Controller Design
K=place(G_d.A, G_d.B, c_pol);

%Observer Design
G22=[0.8159];
G21=[0.05429];
Km=place(G22', G21', 0)';


[num, den]=ss2tf(G_d.A, G_d.B, G_d.C, G_d.D);
P=tf(num, den, T);                      %Plant transfer function
C=tf([6.762 -3.7707], [1 0.0964], T);   %Observer-Controller transfer function
S=feedback(P, C);       %Transfer function of complete system
step(S*2.73)
grid
title('Step response of discretized plant with controller')






