clear
clc

%% System Parameters of Closed Loop Flow
PID_min=0;
PID_max=4096;
PWM_Period=1e-3;    %s

%% Matrix Valve Parameters
Tr= 1e-3; % Rise Time (ms)
K=0.28;   % DC Gain
T=Tr/2.2; % Time Constant

Num_Sys=[K];
Den_Sys=[T 1];
sys=tf(Num_Sys, Den_Sys);
stepinfo(sys)

%% LC Filter Parameters
L=330e-6;
C=220e-6;
Filter=tf([1], [L*C 0 1]);

Filter_Num = [1];
Filter_Den = [L*C 0 1];
w = logspace(-10,10);
h = freqs(Filter_Num,Filter_Den,w);

mag = abs(h);
phase = angle(h);
phasedeg = phase*180/pi;

subplot(2,1,1)
loglog(w/(2*pi),mag)
grid on
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(2,1,2)
semilogx(w/(2*pi),phasedeg)
grid on
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%% Driver Parameters
Gain=256/4096;
Delay=0.01e-4; %s