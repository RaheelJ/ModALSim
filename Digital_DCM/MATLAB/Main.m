clear
clc

N=100;                   %Number of samples
T=0.06;                  %Sampling Time
r=2.73*ones(1, 100);     %Input Signal

for k=1:1
    y(k)=0;     %Initializing first samples of output, error 
                %and controller output
    u(k)=0;
    e(k)=0;
end
xo=[0; 0];

%Model of the plant
A=[0 1; 0 -3.3917];
B=[0; 13.2593];
C=[1 0];
D=0;
G=ss(A, B, C, D);

%Transfer Function of Controller
D=tf([6.762 -3.771], [1 0.0964], T);

%Step response of system with observer based state feedback controller
for k=2:N 
e(k)=r(k)-u(k-1);
%ZOH
l=0:0.06/6:0.06;        %System is so fast that it can change output 6 times during a sampling period
e_h=[e(k) e(k) e(k) e(k) e(k) e(k) e(k)];
[y_h, l, x]=lsim(G, e_h, l, xo);
xo=x(7, :)';            %Previous States
%Sampling of Output
y(k)=y_h(7);
u(k)=controller(y, u, k, D.num{1}, D.den{1});   %Observer-Controller output
end

%Results
hold off
plot([1:N]*T, y)
hold on
plot([1:N]*T, e, 'k--')
grid
title('Step response of system with observer based state feedback controller')
xlabel('Time (Sec)')
ylabel('Amplitude')
