clear
clc

%Parameters of System
L=0.07;
R=3.85;
g=9.8;
m=0.1;
C=3e-4;

%Equilibrium values of variables
x01=0.02;
x03=x01*sqrt(g*m/C);
%Parameters for Transfer Function
a=(2*C*x03*x03)/(m*x01*x01*x01);
b=(2*C*x03)/(L*x01*x01);
c=(-2*C*x03)/(m*x01*x01);
d=-R/L;
e=1/L;

%Calculation of Plant Transfer Function
num1=c*e;
den1=[1 -d -(a+b*c) a*d];
sys1=tf(num1, den1);

%Transfer Function of Controller 
num2=[0.000289 0.0323 0.35 1];
den2=[1 0];
K=-2500;
sys2=tf(K*num2, den2);

%Transfer Function of Complete System
sys=feedback(sys1*sys2, 1);

%Response
rlocus(sys1)%Root Locus of Plant
title('Root Locus of Plant')
pause
rlocus(sys)%Root Locus of System
title('Root Locus of System')
pause
step(sys)%Step Response of System
title('Step Response of System')

