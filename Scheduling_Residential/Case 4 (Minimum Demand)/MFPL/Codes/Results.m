clc
close all


%% Output/display

disp('Case 4 (MFPL):');
disp('||');

%Fridge
disp(['Fridge = ',num2str(E_fr),' kwh', ' --> ', num2str(C_fr),' $']);

%AC/Inverter
disp(['Simple AC = ',num2str(E_ac),' kwh',' --> ',num2str(C_ac),' $']);

%Water Heater
disp(['Water Heater (Electric) = ',num2str(E_wh),' kwh',' --> ',num2str(C_wh),' $']);

%Gas Heater
E_gh=2*E_wh;
C_gh=E_gh*Cg/100;
disp(['Water Heater (Gas) = ',num2str(E_gh),' kwh',' --> ',num2str(C_gh),' $']);

%Tub Heater
disp(['Tub Heater = ',num2str(E_th),' kwh',' --> ',num2str(C_th),' $']);

%Dish Washer
disp(['Dish Washer = ',num2str(E_dw),' kwh',' --> ',num2str(C_dw),' $']);

%Pool Pump
disp(['Pool Pump = ',num2str(E_pp),' kwh',' --> ',num2str(C_pp),' $']);

%Washer
disp(['Washer = ',num2str(E_w),' kwh',' --> ',num2str(C_w),' $']);

%Dryer
disp(['Dryer = ',num2str(E_d),' kwh',' --> ',num2str(C_d),' $']);

%Stove
disp(['Electric Stove = ',num2str(E_st),' kwh',' --> ',num2str(C_st),' $']);

%Lights
disp(['Lightings = ',num2str(E_l),' kwh',' --> ',num2str(C_l),' $']);


%% Other data

disp('||');
disp(['Value of objective function  = ',num2str(fmin)]);

%Total Consumption
E_total=E_fr+E_ac+E_wh+E_dw+E_pp+E_st+E_l+E_th+E_w+E_d;
C_total=C_fr+C_ac+C_wh+C_dw+C_pp+C_st+C_l+C_th+C_w+C_d;
disp(['Total Consumption = ',num2str(E_total),' kwh',' --> ',num2str(C_total),' $']);

%ESD
disp(['ESD Revenue = ',num2str(-1*E_esd),' kwh',' --> ',num2str(-1*Co_esd),' $']);

%Emissions
Eem=15*1e-3/60*(P_wh*best_wh+P_dw*best_dw+P_pp*best_pp+P_st*best_st+P_l*best_l+P_th*best_th+P_w*best_w+P_d*best_d-P_esd*best_esd);
Eem_ac=7.5*1e-3/60*(P_fr*best_fr+P_ac*best_ac);
Emission=sum(Eem.*(Rc*Sc'+Rg*Sg'))+sum(Eem_ac.*(Rc*Sc_ac'+Rg*Sg_ac'))+E_gh*Rg;
disp(['Total emissions = ',num2str(Emission), ' Kg', ' --> ',num2str(ECbest),' $']);

%Peak Load
disp(['Peak Load = ',num2str(Pbest_max), ' KW',' --> ',num2str(Pbest_max*Pcost),' $']);

%Time axis
t_ac=7.5*(0:191);
t=15*(0:95);


%% Output plot (Fridge)
figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t_ac,best_fr,'Parent',axes1,'LineWidth',3);
set(plot1,'Color',[1 0 0],'DisplayName','Status of fridge');
plot2 = plot(t_ac,Tbest_fr,'Parent',axes1,'LineWidth',3);
set(plot2,'DisplayName','Temperature inside fridge');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Temperature (^oC)','FontSize',12);
% Create title
title('Inner temperature profile of fridge','FontSize',12);
% Create legend
legend(axes1,'show');

 
%% Output plot (AC)
figure2 = figure;
% Create axes
axes2 = axes('Parent',figure2,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes2,'on');
grid(axes2,'on');
hold(axes2,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t_ac,10*best_ac,'Parent',axes2,'LineWidth',3);
set(plot1,'Color',[1 0 0],'DisplayName','Status of AC');
plot2 = plot(t_ac,Tbest_in,'Parent',axes2,'LineWidth',3);
set(plot2,'DisplayName','Indoor temperature');
plot3 = plot(t_ac,Tmax_in,'Parent',axes2,'LineWidth',3);
set(plot3,'Color',[0 1 0],'DisplayName','Max Set point');
plot4 = plot(t_ac,Tmin_in,'Parent',axes2,'LineWidth',3);
set(plot4,'Color',[0 1 1],'DisplayName','Min Set point');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Temperature (^oC)','FontSize',12);
% Create title
title('Indoors temperature profile','FontSize',12);
% Create legend
legend(axes2,'show');


%% Output plot (Water Heater)
figure3 = figure;
% Create axes
axes3 = axes('Parent',figure3,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes3,'on');
grid(axes3,'on');
hold(axes3,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t,30*best_wh,'Parent',axes3,'LineWidth',3);
set(plot1,'Color',[1 0 0],'DisplayName','Status of Heater');
plot2 = plot(t,Tbest_wh,'Parent',axes3,'LineWidth',3);
set(plot2,'DisplayName','Temperature of water');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Temperature (^oC)','FontSize',12);
% Create title
title('Temperature profile of the water heater','FontSize',12);
% Create legend
legend(axes3,'show');


%% Output plot (Dish Washer)
figure4 = figure;
% Create axes
axes4 = axes('Parent',figure4,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes4,'on');
grid(axes4,'on');
hold(axes4,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t,best_dw,'Parent',axes4,'LineWidth',3);
set(plot1,'DisplayName','Status of dish washer');
plot2 = plot(t,ubest_dw,'Parent',axes4,'LineWidth',3);
set(plot2,'Color',[0 1 0],'DisplayName','ON signal');
plot3 = plot(t,dbest_dw,'Parent',axes4,'LineWidth',3);
set(plot3,'Color',[1 0 0],'DisplayName','OFF signal');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Status','FontSize',12);
% Create title
title('Operation of dish washer','FontSize',12);
% Create legend
legend(axes4,'show');


%% Output plot (ESD)
figure5 = figure;
% Create axes
axes5 = axes('Parent',figure5,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes5,'on');
grid(axes5,'on');
hold(axes5,'all');
% Create multiple lines using matrix input to plot
plot1 = stem(t,best_esd,'Parent',axes5,'LineWidth',3);
set(plot1,'DisplayName','Discharging signal');
plot4 = stairs(t,Ebest_esd,'Parent',axes5,'LineWidth',3);
set(plot4,'Color',[1 0 1],'DisplayName','Stored energy in ESD');
plot5 = plot(t,abest_esd,'Parent',axes5,'LineWidth',3);
set(plot5,'Color',[0 1 1],'DisplayName','Charging signal');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Energy (kwh)','FontSize',12);
% Create title
title('Operation cycle of ESD','FontSize',12);
% Create legend
legend(axes5,'show');
% 
% 
%% Output plot (Pool Pump)
figure6 = figure;
% Create axes
axes6 = axes('Parent',figure6,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes6,'on');
grid(axes6,'on');
hold(axes6,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t,best_pp,'Parent',axes6,'LineWidth',3);
set(plot1,'DisplayName','Status of pool pump');
plot2 = plot(t,ubest_pp,'Parent',axes6,'LineWidth',3);
set(plot2,'Color',[0 1 0],'DisplayName','ON signal');
plot3 = plot(t,dbest_pp,'Parent',axes6,'LineWidth',3);
set(plot3,'Color',[1 0 0],'DisplayName','OFF signal');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Status','FontSize',12);
% Create title
title('Operation of pool pump','FontSize',12);
% Create legend
legend(axes6,'show');


%% Output plot (Stove)
figure7 = figure;
% Create axes
axes7 = axes('Parent',figure7,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes7,'on');
grid(axes7,'on');
hold(axes7,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t,best_st,'Parent',axes7,'LineWidth',3);
set(plot1,'DisplayName','Status of stove');
plot2 = plot(t,ubest_st,'Parent',axes7,'LineWidth',3);
set(plot2,'Color',[0 1 0],'DisplayName','ON signal');
plot3 = plot(t,dbest_st,'Parent',axes7,'LineWidth',3);
set(plot3,'Color',[1 0 0],'DisplayName','OFF signal');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Status','FontSize',12);
% Create title
title('Operation of electric stove','FontSize',12);
% Create legend
legend(axes7,'show');


%% Output plot (Lights)
figure8 = figure;
% Create axes
axes8 = axes('Parent',figure8,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes8,'on');
grid(axes8,'on');
hold(axes8,'all');
% Create multiple lines using matrix input to plot
plot1 = stairs(t,best_l,'Parent',axes8,'LineWidth',3);
set(plot1,'DisplayName','Illumination of lights');
plot2 = stairs((0:23)*4*15,Lo,'Parent',axes8,'LineWidth',3);
set(plot2,'Color',[0 1 0],'DisplayName','Outdoor illumination');
plot3 = stairs((0:23)*4*15,Lr,'Parent',axes8,'LineWidth',3);
set(plot3,'Color',[1 0 0],'DisplayName','Required illumination');
% Create xlabel
xlabel('Time (min)','FontSize',12);
% Create ylabel
ylabel('Illumination (pu)','FontSize',12);
% Create title
title('Status of zonal lightings','FontSize',12);
% Create legend
legend(axes8,'show');

%% Output plot (Tub Heater)
% figure9 = figure;
% %Create axes
% axes9 = axes('Parent',figure9,...
%     'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
%     'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
%     'FontSize',12);
% box(axes9,'on');
% grid(axes9,'on');
% hold(axes9,'all');
% %Create multiple lines using matrix input to plot
% plot1 = stairs(t,best_th,'Parent',axes9,'LineWidth',3);
% set(plot1,'Color',[1 0 0],'DisplayName','Status of the Heater');
% %Create xlabel
% xlabel('Time (min)','FontSize',12);
% %Create ylabel
% ylabel('Temperature (^oC)','FontSize',12);
% %Create title
% title('Temperature profile of the tub Heater','FontSize',12);
% %Create legend
% legend(axes9,'show');


%% Output plot (Washer/Dryer)
figure10 = figure;
%Create axes
axes10 = axes('Parent',figure10,...
    'XTickLabel',{'0','','','','60','','','','120','','','','180','','','','240','','','','300','','','','360','','','','420','','','','480','','','','540','','','','600','','','','660','','','','720','','','','780','','','','840','','','','900','','','','960','','','','1020','','','','1080','','','','1140','','','','1200','','','','1260','','','','1320','','','','1380','','','','1440','','','','1500'},...
    'XTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360 375 390 405 420 435 450 465 480 495 510 525 540 555 570 585 600 615 630 645 660 675 690 705 720 735 750 765 780 795 810 825 840 855 870 885 900 915 930 945 960 975 990 1005 1020 1035 1050 1065 1080 1095 1110 1125 1140 1155 1170 1185 1200 1215 1230 1245 1260 1275 1290 1305 1320 1335 1350 1365 1380 1395 1410 1425 1440 1455 1470 1485 1500],...
    'FontSize',12);
box(axes10,'on');
grid(axes10,'on');
hold(axes10,'all');
%Create multiple lines using matrix input to plot
plot2 = stem(t,best_w,'Parent',axes10,'LineWidth',3);
set(plot2,'Color',[0 1 0],'DisplayName','Washer status');
plot3 = stem(t,best_d,'Parent',axes10,'LineWidth',3);
set(plot3,'Color',[1 0 0],'DisplayName','Dryer status');
%Create xlabel
xlabel('Time (min)','FontSize',12);
%Create ylabel
ylabel('Status','FontSize',12);
%Create title
title('Operation of washer/dryer','FontSize',12);
%Create legend
legend(axes10,'show');
