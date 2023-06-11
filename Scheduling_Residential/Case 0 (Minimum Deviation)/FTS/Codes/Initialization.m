clc
close all


%% Default parameters
para=[50 0.5];
n=para(1);          % Population size, typically 10 to 25
p=para(2);          % probabibility switch

% Iteration parameters
N_iter=600;         % Total number of iterations


%% Initialization of load variables

% Dimension of the search variables
d_ac=m_ac;
d=m;

%Fridge 
s_fr=round(rand(d_ac, n));
Temp_fr=zeros(d_ac, n);
Temp_fr(1, :)=Tset_fr*ones(1, n);

%AC/Inverter
s_ac=round(rand(d_ac, n));
Temp_in=zeros(d_ac, n);
Temp_in(1, :)=Tset_in*ones(1, n);

%Water Heater
s_wh=round(rand(d, n));
Temp_wh=zeros(d, n);
Temp_wh(1, :)=Tset_wh*ones(1, n);

%Tub Heater
s_th=round(rand(d, n));

%Dish Washer
u_dw=zeros(d, n);
d_dw=zeros(d, n);
%A technique to initialize a balanced population
t_dw=zeros(ceil(mso_dw/mu_dw)*ceil(rot_dw/mso_dw), n);
for i=1:50
    j=round(rand(1, ceil(mso_dw/mu_dw)*ceil(rot_dw/mso_dw))*(Lt_dw-Et_dw));
    t_dw(:, i)=j+Et_dw;
    u_dw(t_dw(:, i), i)=1;
end
s_dw=zeros(d, n);

%ESD
u_esd=round(rand(d, n));            %Discharge signal ON
d_esd=round(rand(d, n));            %Discharge signal OFF
a_esd=round(rand(d, n));            %Charging signal if not defined in function                    
s_esd=zeros(d, n);                  %Discharging status
C_esd=zeros(d, n);                  %Stored energy
C_esd(1, :)=Eset_esd*ones(1, n);
delta_esd=zeros(d, n);              %Energy discharged at an interval

%Pool Pump
u_pp=zeros(d, n);
d_pp=zeros(d, n);
%A technique to initialize a balanced population
t_pp=zeros(4*ceil(mso_pp/mu_pp)*ceil(rot_pp/mso_pp), n);
for i=1:50
    j=round(rand(1, 4*ceil(mso_pp/mu_pp)*ceil(rot_pp/mso_pp))*(Lt_pp-Et_pp-mso_pp));
    t_pp(:, i)=j+Et_pp;
    t_pp(:, i)=sort(t_pp(:, i));
    for j=1:4*ceil(mso_pp/mu_pp)*ceil(rot_pp/mso_pp)-1
        if t_pp(j+1, i)-t_pp(j, i)<=mu_pp+md_pp
            t_pp(j+1, i)=t_pp(j, i)+mu_pp+md_pp;
        end
    end
    j=t_pp(:, i)>Lt_pp;
    t_pp(j, i)=Lt_pp;
    u_pp(t_pp(:, i), i)=1;
end
s_pp=zeros(d, n);

%Stove
u_st=zeros(d, n);
d_st=zeros(d, n);
%A technique to initialize a balanced population
t_st=zeros(ceil(mso_st/mu_st)*ceil(rot_st/mso_st), n);
for i=1:50
    j=round(rand(1, ceil(mso_st/mu_st)*ceil(rot_st/mso_st))*(Lt_st-Et_st-mso_st));
    t_st(:, i)=j+Et_st;
    u_st(t_st(:, i), i)=1;
end
s_st=zeros(d, n);

%Light
s_l=zeros(d, n);

%Washer/Dryer
u_w=zeros(d, n);
d_w=zeros(d, n);
u_d=zeros(d, n);
d_d=zeros(d, n);
%A technique to initialize a balanced population
t_w=zeros(ceil(mso_w/mu_w)*ceil(rot_w/mso_w), n);
t_d=zeros(ceil(mso_w/mu_w)*ceil(rot_w/mso_w), n);
for i=1:50
    j=round(rand(1, ceil(mso_w/mu_w)*ceil(rot_w/mso_w))*(Lt_w-Et_w-2*mso_w));
    t_w(:, i)=j+Et_w;
    u_w(t_w(:, i), i)=1;
    t_d(:, i)=t_w(:, i)+mu_w+round(rand*(mso_w-mu_w))+round(rand*d_wd);
    u_d(t_d(:, i), i)=1;
end
s_w=zeros(d, n);
s_d=zeros(d, n);


%% Initialize the population/solutions

for i=1:n
    
    %AC/Inverter
    [s_ac(:, i), Temp_in(:, i)]=ACI(s_ac(:, i), Tmax_in, Tmin_in, Temp_in(:, i), taw_ac, T, OFF_ac, ON_ac, Leak_ac, A_ac, Tout);
    
    %Fridge
    [s_fr(:, i), Temp_fr(:, i)]=Fridge(s_fr(:, i), Tmax_fr, Tmin_fr, Temp_fr(:, i), taw_ac, T, Et_fr, Lt_fr, OFF_fr, ON_fr, Leak_fr, A_fr);
    
    %Water Heater
    [s_wh(:, i), Temp_wh(:, i)]=WHeater(s_wh(:, i), Tmax_wh, Tmin_wh, Temp_wh(:, i), taw, T, Et_wh, Lt_wh, OFF_wh, ON_wh, Leak_wh, A_wh);
    
    %Tube Heater
    [s_th(:, i)]=THeater(s_th(:, i), taw, T, Et_th, Lt_th);
    
    %Dish Washer
    [u_dw(:, i), d_dw(:, i), s_dw(:, i)]=DWasher(u_dw(:, i), d_dw(:, i), taw, T, Et_dw, Lt_dw, rot_dw, mso_dw, mu_dw, md_dw, M_dw);
    
    %ESD
    [u_esd(:, i), d_esd(:, i), a_esd(:, i), s_esd(:, i), C_esd(:, i), delta_esd(:, i)]=ESD(u_esd(:, i), d_esd(:, i), C_esd(:, i), taw, T, Emax_esd, Emin_esd, mu_esd, md_esd, Cc_esd, Cd_esd);
    
    %Pool Pump
    [u_pp(:, i), d_pp(:, i), s_pp(:, i)]=PPump(u_pp(:, i), d_pp(:, i), taw, T, Et_pp, Lt_pp, rot_pp, mso_pp, mu_pp, md_pp, M_pp);
    
    %Stove
    [u_st(:, i), d_st(:, i), s_st(:, i)]=Stove(u_st(:, i), d_st(:, i), taw, T, Et_st, Lt_st, rot_st, mso_st, mu_st, M_st);
    
    %Light
    s_l(:, i)=Light(Lo, Lr, K, taw, T);
    
    %Washer/Dryer
    [u_w(:, i), d_w(:, i), s_w(:, i), u_d(:, i), d_d(:, i), s_d(:, i)]=Washer(u_w(:, i), d_w(:, i), u_d(:, i), d_d(:, i));

    %Fitness function
    [Fitness(i), J1, J2, J3, J4, J5, J6, J7, J8, J9, J10, J11, P_max(i), EC(i)]=J(s_fr(:, i), Temp_fr(:, i), s_ac(:, i), Temp_in(:, i), s_wh(:, i), Temp_wh(:, i), s_dw(:, i), s_esd(:, i), a_esd(:, i), s_pp(:, i), s_st(:, i), s_l(:, i), s_th(:, i), s_w(:, i), s_d(:, i));
    E1(i)=J1(1);
    C1(i)=J1(2);
    E2(i)=J2(1);
    C2(i)=J2(2);
    E3(i)=J3(1);
    C3(i)=J3(2);
    E4(i)=J4(1);
    C4(i)=J4(2);
    E5(i)=J5(1);
    C5(i)=J5(2);
    E6(i)=J6(1);
    C6(i)=J6(2);
    E7(i)=J7(1);
    C7(i)=J7(2);
    E8(i)=J8(1);
    C8(i)=J8(2);
    E9(i)=J9(1);
    C9(i)=J9(2);
    E11(i)=J10(1);
    C11(i)=J10(2);
    E12(i)=J11(1);
    C12(i)=J11(2);
    
end

%% Find the current best

[fmin, I]=min(Fitness);

%Fridge
best_fr=s_fr(:,I);
Tbest_fr=Temp_fr(:, I);
E_fr=E1(I);
C_fr=C1(I);

%AC/Inverter
best_ac=s_ac(:,I);
Tbest_in=Temp_in(:, I);
E_ac=E2(I);
C_ac=C2(I);

%Water Heater
best_wh=s_wh(:,I);
Tbest_wh=Temp_wh(:, I);
E_wh=E3(I);
C_wh=C3(I);

%Dish Washer
best_dw=s_dw(:, I);
ubest_dw=u_dw(:, I);
dbest_dw=d_dw(:, I);
tbest_dw=t_dw(:, I);
E_dw=E4(I);
C_dw=C4(I);

%ESD
best_esd=s_esd(:, I);
abest_esd=a_esd(:, I);
ubest_esd=u_esd(:, I);
dbest_esd=d_esd(:, I);
Ebest_esd=C_esd(:, I);
E_esd=E5(I);
Co_esd=C5(I);

%Pool Pump
best_pp=s_pp(:, I);
ubest_pp=u_pp(:, I);
dbest_pp=d_pp(:, I);
tbest_pp=t_pp(:, I);
E_pp=E6(I);
C_pp=C6(I);

%Stove
best_st=s_st(:, I);
ubest_st=u_st(:, I);
dbest_st=d_st(:, I);
tbest_st=t_st(:, I);
E_st=E7(I);
C_st=C7(I);

%Light
best_l=s_l(:, I);
E_l=E8(I);
C_l=C8(I);

%Tube Heater
best_th=s_th(:,I);
E_th=E9(I);
C_th=C9(I);

%Washer/Dryer
best_d=s_d(:, I);
ubest_d=u_d(:, I);
dbest_d=d_d(:, I);
tbest_d=t_d(:, I);
E_d=E12(I);
C_d=C12(I);
best_w=s_w(:, I);
ubest_w=u_w(:, I);
dbest_w=d_w(:, I);
tbest_w=t_w(:, I);
E_w=E11(I);
C_w=C11(I);

%Peak load and emission cost
Pbest_max=P_max(I);
ECbest=EC(I);