%% Objective function

function [z, J_fr, J_ac, J_wh, J_dw, J_esd, J_pp, J_st, J_l, J_th, J_w, J_d, P_max, z3]=J(s_fr, T_fr, s_ac, T_in, s_wh, T_wh, s_dw, s_esd, a_esd, s_pp, s_st, s_l, s_th, s_w, s_d)

%Powers
P_fr=600;
P_ac=2200;
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
TOU=[8*ones(1, 6*4) 12*ones(1, 5*4) 13*ones(1, 5*4) 12*ones(1, 4*4) 8*ones(1, 4*4)];
TOU_ac=[8*ones(1, 6*8) 12*ones(1, 5*8) 13*ones(1, 5*8) 12*ones(1, 4*8) 8*ones(1, 4*8)];
TOU_ac=TOU_ac';
TOU=TOU';
Cg=30;
Ces=80;             
scc=100;            %Social emission cost/ton


%% Emissions

%Forcasted generations
Pc(1:12)=1000*[2.023 1.921 2.093 2.048 2.221 2.725 3.278 3.623 3.768 3.655 3.737 3.917];
Pc(13:24)=1000*[3.624 3.659 3.192 3.392 3.578 3.571 3.699 3.850 3.784 3.763 3.399 3.031];
Pg(1:12)=1000*[1.122 1.099 1.089 1.092 1.117 1.393 1.737 2.151 2.401 2.428 2.551 2.730];
Pg(13:24)=1000*[2.639 2.674 2.384 2.343 2.466 2.554 2.696 2.732 2.501 2.250 1.830 1.424];

%Observed generations
Po(1:12)=[18133 17955 18044 17962 18161 19278 21048 22578 22887 23065 23123 23251];
Po(13:24)=[22749 22782 21851 22292 23137 23911 23986 24091 23585 22707 21548 19964];
tot_em(1:12)=[2641 2526 2696 2651 2840 3497 4238 4803 5079 4978 5125 5401];
tot_em(13:24)=[5055 5109 4484 4666 4919 4957 5161 5334 5148 4997 4410 3825];

%Cost/kwh
Rc=1.0201;
Rg=0.5148;
R1=Pc./Po;
R2=Pg./Po;

Cem1(1:12)=[1.46 1.41 1.49 1.48 1.56 1.81 2.01 2.13 2.22 2.16 2.22 2.32];
Cem1(13:24)=[2.22 2.24 2.05 2.09 2.13 2.07 2.15 2.21 2.18 2.2 2.05 1.92];

k=1;
for i=1:8:192
    for j=i:i+7
        Cem_ac(j)=Cem1(k);
    end
    k=k+1;
end
Cem_ac=Cem_ac';

k=1;
for i=1:4:96
    for j=i:i+3
        Cem(j)=Cem1(k);
    end
    k=k+1;
end
Cem=Cem';

%% J1 (Energy Optimization)

E_ac=(sum(P_ac*s_ac)*7.5*(1e-3)/60);
E_fr=sum(P_fr*s_fr)*7.5*(1e-3)/60;
E_wh=sum(P_wh*s_wh)*15*(1e-3)/60;
E_dw=sum(P_dw*s_dw)*15*(1e-3)/60;
E_esd=-(sum(P_esd*s_esd)*15*(1e-3)/60);
E_pp=sum(P_pp*s_pp)*15*(1e-3)/60;
E_st=sum(P_st*s_st)*15*(1e-3)/60;
E_l=sum(P_l*s_l)*15*(1e-3)/60;
E_th=sum(P_th*s_th)*15*(1e-3)/60;
E_gh=sum(P_gh*s_wh)*15*(1e-3)/60;
E_w=sum(P_w*s_w)*15*(1e-3)/60;
E_d=sum(P_d*s_d)*15*(1e-3)/60;

z1=E_fr+E_ac+E_wh+E_dw+E_esd+E_pp+E_st+E_l+E_th+E_w+E_d;


%% J2 (Cost Optimization)

C_ac=(sum(P_ac*(s_ac.*TOU_ac))*7.5*(1e-3)/6000);
C_fr=sum(P_fr*(s_fr.*TOU_ac))*7.5*(1e-3)/6000;
C_wh=sum(P_wh*(s_wh.*TOU))*15*(1e-3)/6000;
C_dw=sum(P_dw*(s_dw.*TOU))*15*(1e-3)/6000;
C_esd=-sum(P_esd*(s_esd.*Ces))*15*(1e-3)/6000;
C_pp=sum(P_pp*(s_pp.*TOU))*15*(1e-3)/6000;
C_st=sum(P_st*(s_st.*TOU))*15*(1e-3)/6000;
C_l=sum(P_l*(s_l.*TOU))*15*(1e-3)/6000;
C_th=sum(P_th*(s_th.*TOU))*15*(1e-3)/6000;
C_gh=sum(P_gh*(s_wh.*Cg))*15*(1e-3)/6000;
C_w=sum(P_w*(s_w.*TOU))*15*(1e-3)/6000;
C_d=sum(P_d*(s_d.*TOU))*15*(1e-3)/6000;

z2=(5*C_ac+C_fr)+2*(C_wh+C_dw+C_pp+C_st+C_w+C_d)+C_th+C_l+C_esd;


%% J3 (Emissions Optimization)

G_ac=(sum(P_ac*(s_ac.*Cem_ac))*7.5*(1e-3)/6000);
G_fr=sum(P_fr*(s_fr.*Cem_ac))*7.5*(1e-3)/6000;
G_wh=sum(P_wh*(s_wh.*Cem))*15*(1e-3)/6000;
G_dw=sum(P_dw*(s_dw.*Cem))*15*(1e-3)/6000;
G_esd=-(sum(P_esd*(s_esd.*Cem))*15*(1e-3)/6000);
G_pp=sum(P_pp*(s_pp.*Cem))*15*(1e-3)/6000;
G_st=sum(P_st*(s_st.*Cem))*15*(1e-3)/6000;
G_l=sum(P_l*(s_l.*Cem))*15*(1e-3)/6000;
G_th=sum(P_th*(s_th.*Cem))*15*(1e-3)/6000;
G_gh=E_gh*scc*Rg/1000;
G_w=sum(P_w*(s_w.*Cem))*15*(1e-3)/6000;
G_d=sum(P_d*(s_d.*Cem))*15*(1e-3)/6000;

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


Eem=15*1e-3/60*(P_wh*s_wh+P_dw*s_dw+P_pp*s_pp+P_st*s_st+P_l*s_l+P_th*s_th+P_w*s_w+P_d*s_d-P_esd*s_esd);
Eem_ac=7.5*1e-3/60*(P_fr*s_fr+P_ac*s_ac);
Emission=sum(Eem.*(Rc*Sc'+Rg*Sg'))+sum(Eem_ac.*(Rc*Sc_ac'+Rg*Sg_ac'))+E_gh*Rg;

z3=(G_fr+5*G_ac+2*G_wh+2*G_gh+2*G_dw+G_esd+2*G_pp+2*G_st+G_th+2*G_w)+2*G_d+G_l;


%% J4 (Set Point Optimization)
Tset_aci=zeros(192, 1);
Tset_aci(1:36*2)=22*ones(36*2, 1);
Tset_aci(36*2+1:64*2)=30*ones(28*2, 1);
Tset_aci(64*2+1:88*2)=23*ones(24*2, 1);
Tset_aci(88*2+1:96*2)=22*ones(8*2, 1);
Tset_fr=3.5*ones(192, 1);
Tset_wh=53*ones(96, 1);
Tset_in=22*ones(192, 1);

z4=sum((T_in-Tset_aci).^2)+sum((T_fr-Tset_fr).^2)+sum((T_wh-Tset_wh).^2);


%% J5 (Peak Demand Optimization)

k=1;
for i=1:2:192
    for j=i:i+1
        s_wh1(j)=s_wh(k);
    end
    k=k+1;
end
s_wh1=s_wh1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_d1(j)=s_d(k);
    end
    k=k+1;
end
s_d1=s_d1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_w1(j)=s_w(k);
    end
    k=k+1;
end
s_w1=s_w1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_th1(j)=s_th(k);
    end
    k=k+1;
end
s_th1=s_th1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_dw1(j)=s_dw(k);
    end
    k=k+1;
end
s_dw1=s_dw1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_pp1(j)=s_pp(k);
    end
    k=k+1;
end
s_pp1=s_pp1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_esd1(j)=s_esd(k);
    end
    k=k+1;
end
s_esd1=s_esd1';

k=1;
for i=1:2:192
    for j=i:i+1
        a_esd1(j)=a_esd(k);
    end
    k=k+1;
end
a_esd1=a_esd1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_l1(j)=s_l(k);
    end
    k=k+1;
end
s_l1=s_l1';

k=1;
for i=1:2:192
    for j=i:i+1
        s_st1(j)=s_st(k);
    end
    k=k+1;
end
s_st1=s_st1';

s_max=s_fr+s_ac+s_wh1+s_dw1+s_pp1+s_st1+s_l1+s_th1+s_w1+s_d1;
[maximum, I]=max(s_max);
P_max=s_fr(I)*P_fr+s_ac(I)*P_ac+s_wh1(I)*P_wh+s_dw1(I)*P_dw+s_pp1(I)*P_pp+s_st1(I)*P_st+s_l1(I)*P_l+s_th1(I)*P_th+s_w1(I)*P_w+s_d1(I)*P_d;
P_max=P_max/1000;

z5=5*z2+P_max;


%% Mixed optimization
X=-10.412;
Y=13.3813;
Z=1.1972;
z6=z2+abs(X/Y)*z1+abs(X/Z)*z3;


%% Choosing the objective function

z=z5;

J_ac=[E_ac C_ac];
J_fr=[E_fr C_fr];
J_wh=[E_wh C_wh];
J_dw=[E_dw C_dw];
J_esd=[E_esd C_esd];
J_pp=[E_pp C_pp];
J_st=[E_st C_st];
J_l=[E_l C_l];
J_th=[E_th C_th];
J_d=[E_d C_d];
J_w=[E_w C_w];


end