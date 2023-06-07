clear
clc
close all

ts=1:0.1:2000;             %Time for solution
tu=ts;                   
ut=20*sin(2*3.142*8*tu);        %Input signal

Am=blkdiag(-1, -3, -2);    %Am matrix calculation

setlmis([]);               %Solution of LMI for P
P=lmivar(1, [3, 1]);
lmiterm([1 1 1 P], Am', 1, 's');
lmiterm([-2 1 1 P], 1, 1);
lmisys=getlmis;
[T, X]=feasp(lmisys);
P=dec2mat(lmisys, X, P);

%System Parameters
R=2;        %Ohms
L=0.5;      %Henrys
Kt=0.1; 
Kb=0.1;
b=0.2;      %Nms
J=0.02;     %kg.m^2/s^2
A=[-R/L 0 -Kb/L; 0 0 1; Kt/J 0 -b/J]
B=[1/L; 0; 0]

%Solution of differential equations
yo(1:11)=zeros(1, 11);
[tss, y] = ode45(@(t, y) AC_MI(t, y, A, B, ut, tu, Am, P), ts, yo);

%Final value of found parameters
N=size(tss);
n=max(N);
a1=y(n, 7)
a2=y(n, 8)
a3=y(n, 9)
a4=y(n, 10)
b1=y(n, 11)

%Plots of parameters and errors vs time
figure
plot(tss, y(:, 4)-y(:, 1));
title('Error for state x1')
xlabel('Time (sec)')
ylabel('e1')

figure
plot(tss, y(:, 5)-y(:, 2));
title('Error for state x2')
xlabel('Time (sec)')
ylabel('e2')
grid

figure
plot(tss, y(:, 6)-y(:, 3));
title('Error for state x3')
xlabel('Time (sec)')
ylabel('e3')
grid

figure
plot(tss, y(:, 7));
title('Parameter a1')
xlabel('Time (sec)')
grid

figure
plot(tss, y(:, 8));
title('Parameter a2')
xlabel('Time (sec)')
grid

figure
plot(tss, y(:, 9));
title('Parameter a3')
xlabel('Time (sec)')
grid

figure
plot(tss, y(:, 10));
title('Parameter a4')
xlabel('Time (sec)')
grid

figure
plot(tss, y(:, 11));
title('Parameter b')
xlabel('Time (sec)')
grid