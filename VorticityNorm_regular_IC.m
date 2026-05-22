% This script generates the figure 3, showing the time evolution of the
% supremum norm of the vorticity,
%
%       ||omega(t)||_infinity,
%
% for solutions of the Euler equations and the Navier--Stokes equations.
%
% The Euler solution is used to identify the finite-time blowup behavior,
% while the Navier--Stokes solutions are computed for different Reynolds
% numbers,
%
% Res=[10^4,10^5,10^6,10^7];
%
% The goal is to compare the growth of ||omega(t)||_infinity in the inviscid
% Euler case with its viscous regularization for finite Reynolds numbers.

% Create a new figure window and define its position and size.
% The vector [500 1000 1300 500] specifies
%
%       [left bottom width height].
%
% A wide figure is used because the output contains two panels side by side.
h = figure('Position',[50 500 1500 650]); %set(h, 'Visible', 'off');

% -------------------------------------------------------------------------
% Panel (a): Euler solution and blowup behavior.
% -------------------------------------------------------------------------

% Create the first subplot in a 1-by-2 layout.
ax1=subplot(1,2,1);

% Folder containing the Euler simulation data.
dirname = 'Data/Regular_IC/VorticityNorm/Euler.mat';

% Load the time vector T and the maximum vorticity w_max.
% The variable w_max represents ||omega(t)||_infinity.
load(dirname,'T','w_max');

% Plot ||omega(t)||_infinity as a function of time in semilogarithmic scale.
% The y-axis is logarithmic, which is useful because the vorticity grows
% very rapidly near the blowup time.
semilogy(T,w_max,'-k','LineWidth',2); hold on;

% Approximate blowup time obtained from the Euler simulation.
tb = 0.111909;

% Add a vertical dashed red line indicating the estimated blowup time.
plot([tb tb],[1e1 1e8],'--r','LineWidth',3); hold off;

% Add a vertical text label identifying the blowup time.
text(0.118,1e5,'blowup $t_b \approx 0.112$','FontSize',25,'HorizontalAlignment','center','Interpreter','latex','Rotation',90,'Color','r')

% Improve the visual style of the figure and axes.
set(gcf,'color','w');
set(gca,'LineWidth',1.2);
set(gca,'FontSize',26,'TickLabelInterpreter','latex');

% Set the axis limits:
%   x-axis: time interval before the blowup,
%   y-axis: range of ||omega||_infinity in logarithmic scale.
axis([0 0.13 5e1 2e7]);
% xticks(10.^(-5:-1));
yticks(10.^(2:2:6));

% Add axis labels.
xlabel('$t$','Interpreter','latex')
ylabel('$\|\omega\|_{\infty}$','Interpreter','latex')

% Add panel label.
title('(a)','Interpreter','latex');

% -------------------------------------------------------------------------
% Inset in panel (a): blowup scaling in terms of t_b - t.
% -------------------------------------------------------------------------

% Create a smaller set of axes inside panel (a) with a specific position
a = ax1.Position(1)+0.03; b = 0.45; c = 0.2; d = 0.45;
f_insL = axes('Position',[a b c d]);

% Plot ||omega(t)||_infinity as a function of t_b - t in log-log scale.
% This representation is useful to test power-law behavior near blowup.

Tau = tb - T;
idx = Tau > 0;
Tau = Tau(idx);
loglog(Tau,w_max(idx),'-k','LineWidth',2);
hold on;

% Plot the reference scaling C*(t_b-t)^(-1).
% This line is used to compare the numerical growth with the expected
% blowup rate ||omega(t)||_infinity ~ (t_b-t)^(-1).
loglog(Tau,50*Tau.^(-1),'--b','LineWidth',2);

% Set limits and ticks for the inset.
axis([0.99999e-5 1e-1 1e2 1e7]);
xticks(10.^(-5:-1));
yticks(10.^(0:2:10));

box on;
set(gca,'fontsize',18,'TickLabelInterpreter','latex'); 

% Label the horizontal axis of the inset.
xlabel('$t_b-t$','Interpreter','latex','FontSize',20)

%% -------------------------------------------------------------------------
% Panel (b): comparison between Navier--Stokes and Euler solutions.
% -------------------------------------------------------------------------

% Create the second subplot in the 1-by-2 layout.
ax2=subplot(1,2,2);
ax2.Position = ax1.Position + [0.42 0 0.1 0];

% Reynolds numbers used for the Navier--Stokes simulations.
Res=[10^4,10^5,10^6,10^7];

% Plot the Navier--Stokes solutions for each Reynolds number.
for j=1:4
   
    Re=Res(j);  % Select the current Reynolds number.
    
    % Construct the folder name containing the data for this Reynolds number.    
    str = ['Data/Regular_IC/VorticityNorm/Re=',num2str(Re),'.mat'];
    
    % Load the maximum vorticity w_max and the time vector T.
    load(str,'T','w_max'); 
    
    % Plot ||omega(t)||_infinity for the current Reynolds number.
    % Only the first 4116 time steps are plotted to focus on the relevant
    % time interval near the Euler blowup time.
    semilogy(T(1:4116),w_max,'LineWidth',2);
    hold on;
end

% Load and plot the Euler solution for comparison.
% This curve is interpreted as the inviscid limit Re -> infinity.
load(dirname,'T','w_max');
semilogy(T,w_max,'k-','LineWidth',2);
plot([tb tb],[1e1 1e8],'--r','LineWidth',3);

% Set the axis limits.
axis([0 0.2005 5e1 10^(4.6)]);
yticks([10^(2) 10^(3) 10^(4)]);

box on;

% Improve the visual style of the axes.
set(gcf,'color','w');
set(gca,'LineWidth',1.2);
set(gca,'FontSize',26,'TickLabelInterpreter','latex');

% Add legend identifying each Reynolds number and the Euler solution.
legend('$Re = 10^4$','$Re= 10^5$','$Re= 10^6$','$Re= 10^7$','$Re \to \infty$','FontSize',20,'Location','SouthEast','Interpreter','latex')

% Add axis labels.
xlabel('$t$','Interpreter','latex')
ylabel('$\|\omega\|_{\infty}$','Interpreter','latex')

% Add panel label.
title('(b)','Interpreter','latex');


% -------------------------------------------------------------------------
% Inset in panel (b): scaling of the saturated vorticity with Re.
% -------------------------------------------------------------------------

% Create a smaller set of axes inside panel (b).
f_ins1 = axes('Position',[ax2.Position(1)+0.028 b 0.14 d]);

% Compute a representative saturated vorticity value for each Reynolds number.
for j=1:4


    Re=Res(j); % Select the current Reynolds number.
    
    % Construct the folder name for the corresponding Navier--Stokes data.
    str = ['Data/Regular_IC/VorticityNorm/Re=',num2str(Re),'.mat'];
    load(str,'T','w_max');
    B(j)=mean(w_max(3892:4098));
end

% Plot a reference power law proportional to Re^(0.4).
loglog(Res,22*Res.^(0.4),'-k','LineWidth',1);
hold on;
loglog(Res,B,'or','MarkerSize',10,'LineWidth',2,'MarkerFaceColor','w');

% Set the style and limits of the inset.
set(gca,'fontsize',13); 
axis([1e4 1e7 5e2 2e4]);
xticks(Res);
yticks([1e3 1e4]);
set(gca,'FontSize',18,'TickLabelInterpreter','latex');

% Add horizontal axis label.
xlabel('$Re$','Interpreter','latex','FontSize',20)

% Adjust the figure margins.
tightfig;
