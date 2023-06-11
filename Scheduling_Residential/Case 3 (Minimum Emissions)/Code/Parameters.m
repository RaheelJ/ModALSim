clear
clc
close all


%% Common Parameters
taw=4;              %Number of intervals in an hour
T=24;               %Number of hours
m=taw*T;            %Total number of intervals
t=1:m;              %Vector of intervals

%Same parameters for AC and Fridge
taw_ac=8;       
m_ac=taw_ac*T;
t_ac=1:m_ac;        

Pcost=7;                %Peak demand charges


%% Fridge Data
Et_fr=1;
Lt_fr=96*2;
Tmax_fr=8;
Tset_fr=3.5;            %Initial value of temperature
Tmin_fr=2;
OFF_fr=1.21/2;      
ON_fr=5.5/2;
Leak_fr=0.28/2;         %Parameter showing effect of activity

A_fr(1:12)=100*[0.004 0.002 0 0 0.002 0.007 0.017 0.025 0.022 0.016 0.016 0.02];
A_fr(13:24)=100*[0.027 0.028 0.03 0.033 0.035 0.04 0.04 0.04 0.04 0.04 0.026 0.013];

A_fr=A_fr/max(A_fr);   %To normalize if required (One thesis has used normalized values)


%% Parameters for AC/Inverter
% Tmax_in=23*ones(1, 192);
% Tmin_in=17*ones(1, 192);

Tset_in=22;             %Initial value of temperature
OFF_ac=0.0075/2;           %Parameter showing effect of temperature difference           
ON_ac=0.33/2;
Leak_ac=0.044/2;         %Parameter showing effect of activity

Tmax_in=zeros(192, 1);
Tmax_in(1:36*2)=24*ones(36*2, 1);
Tmax_in(36*2+1:64*2)=31*ones(28*2, 1);
Tmax_in(64*2+1:88*2)=24*ones(24*2, 1);
Tmax_in(88*2+1:96*2)=24*ones(8*2, 1);

Tmin_in=zeros(192, 1);
Tmin_in(1:36*2)=21*ones(36*2, 1);
Tmin_in(36*2+1:64*2)=20*ones(28*2, 1);
Tmin_in(64*2+1:88*2)=22*ones(24*2, 1);
Tmin_in(88*2+1:96*2)=21*ones(8*2, 1);

A_ac(1:12)=100*[0.0125 0.011 0.011 0.011 0.011 0.0125 0.014 0.017 0.02 0.02 0.022 0.022]; 
A_ac(13:24)=100*[0.022 0.023 0.023 0.023 0.025 0.025 0.027 0.027 0.027 0.025 0.017 0.015];

% A_ac=A_ac/max(A_ac); To normalize if required (One thesis has used normalized values)

Tout(1:12)=[24 23 23 23 24 23 23 25 25.5 27 29 30];
Tout(13:24)=[30 30 30 28 28 28 27.5 27 26.5 26 25.5 25.2];


%% Parameters for Water Heater
Tmax_wh=58;
Tset_wh=53;
Tmin_wh=48;
Et_wh=1;
Lt_wh=96;
ON_wh=4.44;
OFF_wh=0.05;
Leak_wh=0.068;          %Parameter for showing the effect of activity

A_wh(1:20)=3;
A_wh(21:28)=24.5;
A_wh(29:40)=16;
A_wh(41:48)=9;
A_wh(49:64)=8;
A_wh(65:72)=12;
A_wh(73:88)=10;
A_wh(89:96)=3;


%% Parameters for Tub Heater
Tmax_th=58;
Tset_th=53;             %Initial vslue
Tmin_th=44;
Et_th=1;
Lt_th=96;


%% Parameters for Dish Washer
Et_dw=65;
Lt_dw=92;
rot_dw=8;
mso_dw=8;
mu_dw=8;
md_dw=4;
M_dw=500;               %A large constant


%% Parameters for ESD
mu_esd=8;
md_esd=2;
Emax_esd=30;
Eset_esd=8;             %Initial charging of ESD
Emin_esd=6;
Cc_esd=0.25;            %Charging constant 
Cd_esd=0.75;            %Discharging constant

%Charging powers are given in the function


%% Parameters for Lighting Load

%Not used in optimization
Lr(1:12)=[0.2*ones(1, 5) 1 1 1 2 2 2 2];                %Required Illumination
Lr(13:24)=[2 2 2 2 2.8*ones(1, 4) 2 2 2 1.2];
Lo(1:12)=[zeros(1, 5) 0.2 0.4 0.5 0.7 1 0.6 1];         %Outdoor Illumination
Lo(13:24)=[1 0.7 0.6 0.5 0.3 0.2 0.1 zeros(1, 5)];
Pu=200;
K=[ones(1, 6) zeros(1, 6) zeros(1, 10) ones(1, 2)];     %Constant 

%K=ones(1, 24);                                       


%% Parameters of Pool Pump
Et_pp=29;
Lt_pp=96;
rot_pp=40;
mso_pp=8;
mu_pp=8;
md_pp=4;
M_pp=500;           %A large constant


%% Parameters of Stove
Et_st=65;
Lt_st=88;
rot_st=12;
mso_st=12;
mu_st=4;
M_st=500;           %A large constant


%% Parameters for Washer and Dryer
%Parameters used in function are given there function
%Modifications should be made here and in the function if required
Et_w=64;
Lt_w=92;
rot_w=8;
mso_w=8;
mu_w=8;
md_w=4;
M_w=500;

s_d=zeros(1, taw*T+1);
mu_d=8;
md_d=4;
d_wd=12;        %Parameter of coordination


%% Misc Calculations 

%(To change power and emission calulation, also make changes in J)

%Powers
P_fr=600;
P_ac=2200;
P_iac=2200;
P_wh=600;
P_gh=1200;
P_th=1500;
P_dw=700;
P_st=1500;
P_l=150;
P_pp=750;
P_esd=3000;
P_w=450;
P_d=1100;

%Tariff
TOU=[7.8*ones(1, 7*4) 11.4*ones(1, 4*4) 12.7*ones(1, 6*4) 11.4*ones(1, 7*4)];
TOU_ac=[7.8*ones(1, 7*8) 11.4*ones(1, 4*8) 12.7*ones(1, 6*8) 11.4*ones(1, 7*8)];
TOU_ac=TOU_ac';
TOU=TOU';
Cg=30;
Ces=80;


%% Emissions

%Forcasted generations of coal and gas power plants
%Pc(1:12)=1000*[2.023 1.921 2.093 2.048 2.221 2.725 3.278 3.623 3.768 3.655 3.737 3.917];
%Pc(13:24)=1000*[3.624 3.659 3.192 3.392 3.578 3.571 3.699 3.850 3.784 3.763 3.399 3.031];
%Pg(1:12)=1000*[1.122 1.099 1.089 1.092 1.117 1.393 1.737 2.151 2.401 2.428 2.551 2.730];
%Pg(13:24)=1000*[2.639 2.674 2.384 2.343 2.466 2.554 2.696 2.732 2.501 2.250 1.830 1.424];

%Corrected forcasted generations of coal and gas power plants (page-22 & 23 figure 2.3 $ 2.4)

Pc(1:12)=[125 64.5 64.5 64.5  64.5 125 300 550 500 600 800 750];
Pc(13:24)=[800 750  600 650 620 750 550 610 500 300 270 250];
Pg(1:12)=[833.33 833.33 960 1050 1130  1300 1650 1875 2000 2250 2450 2450];
Pg(13:24)=[2450 2250 2200 2200 2150 2000 1800 1750 1450 1250 1050 1000];

%Forcasted demand
%Po(1:12)=[18133 17955 18044 17962 18161 19278 21048 22578 22887 23065 23123 23251];
%Po(13:24)=[22749 22782 21851 22292 23137 23911 23986 24091 23585 22707 21548 19964];

%Corrected forcasted demand (page 41 figure 3.5)

Po(1:12)=[14166.5 13870 13750 14375 15000 16250 17500 17708.33 18125 18800 18750 19000];
Po(13:24)=[19262.5 18000 18750  18437.5 18600 18125 18225 18100 16875 16250 15625 15000];

%Total emission per hour
%tot_em(1:12)=[2641 2526 2696 2651 2840 3497 4238 4803 5079 4978 5125 5401];
%tot_em(13:24)=[5055 5109 4484 4666 4919 4957 5161 5334 5148 4997 4410 3825];

%Corrected total emission per hour (page 42 figure 3.6)
tot_em(1:12)=[531.25 562.50 625 750 1000 1500 1600 1625 2000 2125 2125 2150];
tot_em(13:24)=[1815 1800 1800 1814 1700 1565 1500 1200 800 700 670 600];

%Emission/kwh
Rc=1.0201;          
Rg=0.5148;

R1=Pc./Po;
R2=Pg./Po;

k=1;
for i=1:8:192
    for j=i:i+7
        Sc_ac(j)=R1(k);
        Sg_ac(j)=R2(k);
    end
    k=k+1;
end

k=1;
for i=1:4:96
    for j=i:i+3
        Sc(j)=R1(k);
        Sg(j)=R2(k);
    end
    k=k+1;
end
