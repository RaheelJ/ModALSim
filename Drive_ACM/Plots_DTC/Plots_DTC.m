t=linspace(0, 5e-6, 1);

figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1,'FontSize',20);
xlim(axes1,[0 1]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');
% Create stairs
plot(Speed(:, 1), Speed(:, 2),'LineStyle','-.','LineWidth',1.8,'Color',[1 0 0],'Parent',axes1,...
    'DisplayName','Reference Speed (rpm)');
plot(Speed(:, 1), Speed(:, 3),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes1,...
    'DisplayName','Actual Speed (rpm)');
% Create title
ylabel('Speed (rpm)')
xlabel('Time (s)')
legend
title('Speed Response of DTC','FontSize',20);


figure2 = figure;
% Create axes
axes2 = axes('Parent',figure2,'FontSize',20);
xlim(axes2,[0 1]);
box(axes2,'on');
grid(axes2,'on');
hold(axes2,'all');
% Create stairs
plot(Stator_Currents(:, 1), Stator_Currents(:, 2),'LineStyle','-','LineWidth',1.8,'Color',[1 0 0],'Parent',axes2,...
    'DisplayName','I_a (A)');
plot(Stator_Currents(:, 1), Stator_Currents(:, 3),'LineStyle','-','LineWidth',1.8,'Color',[0 0 0],'Parent',axes2,...
    'DisplayName','I_b (A)');
plot(Stator_Currents(:, 1), Stator_Currents(:, 4),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes2,...
    'DisplayName','I_c (A)');
% Create title
ylabel('Current (A)')
xlabel('Time (s)')
legend
title('Stator Currents for DTC','FontSize',20);

figure3 = figure;
% Create axes
axes3 = axes('Parent',figure3,'FontSize',20);
xlim(axes3,[0 1]);
box(axes3,'on');
grid(axes3,'on');
hold(axes3,'all');
% Create stairs
plot(Load_Torque(:, 1), Load_Torque(:, 2),'LineStyle','-.','LineWidth',1.8,'Color',[1 0 0],'Parent',axes3,...
    'DisplayName','Load Torque (N.m)');
plot(Load_Torque(:, 1), Load_Torque(:, 3),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes3,...
    'DisplayName','Electrical Torque (N.m)');
% Create title
ylabel('Torque (N.m)')
xlabel('Time (s)')
legend
title('Load Torque Response for DTC','FontSize',20);

figure4 = figure;
% Create axes
axes4 = axes('Parent',figure4,'FontSize',20);
xlim(axes4,[0 1]);
box(axes4,'on');
grid(axes4,'on');
hold(axes4,'all');
% Create stairs
plot(Flux(:, 1), Flux(:, 2),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes4,...
    'DisplayName','Stator Flux (Wb)');
% Create title
ylabel('Flux (Wb)')
xlabel('Time (s)')
legend
title('Estimated Stator Flux for DTC','FontSize',20);

figure5 = figure;
% Create axes
axes5 = axes('Parent',figure5,'FontSize',20);
xlim(axes5,[0 1]);
box(axes5,'on');
grid(axes5,'on');
hold(axes5,'all');
% Create stairs
plot(Id_Iq(:, 1), Id_Iq(:, 2),'LineStyle','-','LineWidth',1.8,'Color',[1 0 0],'Parent',axes5,...
    'DisplayName','I_q (A)');
plot(Id_Iq(:, 1), Id_Iq(:, 3),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes5,...
    'DisplayName','I_d (A)');
% Create title
ylabel('Current (A)')
xlabel('Time (s)')
legend
title('Quadrature and Direct Current Component for DTC','FontSize',20);

figure6 = figure;
% Create axes
axes6 = axes('Parent',figure6,'FontSize',20);
xlim(axes6,[0 1]);
box(axes6,'on');
grid(axes6,'on');
hold(axes6,'all');
% Create stairs
plot(Torque_Reference(:, 1), Torque_Reference(:, 2),'LineStyle','-.','LineWidth',1.8,'Color',[1 0 0],'Parent',axes6,...
    'DisplayName','Reference Electrical Torque (N.m)');
plot(Torque_Reference(:, 1), Torque_Reference(:, 3),'LineStyle','-','LineWidth',1.8,'Color',[0 0 1],'Parent',axes6,...
    'DisplayName','Actual Electrical Torque (N.m)');
% Create title
ylabel('Torque (N.m)')
xlabel('Time (s)')
legend
title('Electrical Torque Response of DTC','FontSize',20);

