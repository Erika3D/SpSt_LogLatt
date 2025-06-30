
% This code generates the Figures of the  time evolution of the supremum norm 
% of the vorticity ||\omega(t)||_{\infty} for the solution of the Euler equations
% and the Navier-Stokes equations for differents values of Re in the set
%
% Res=[10^4,10^5,10^6,10^7];


Res=[10^4,10^5,10^6,10^7];

dirname = 'Regular_IC_Data/VorticityNorm/';
load([dirname,'Euler.mat'],'T','w_max');
l1=semilogy(T,w_max,'LineWidth',2);

hold on;
for j=1:4
    Re=Res(j);
    dirname = 'Regular_IC_Data/VorticityNorm/';
    str= ['Re=',num2str(Re)];
    load([dirname,str],'T','w_max');
    semilogy(T(1:4116),w_max,'LineWidth',2);
end

xline(0.1125, '--','Linewidth',2, 'Color', [0.1 0.1 0.1]);
uistack(l1,'top');
axis([0 0.2005 0 10^(4.5)]);
yticks([10^(2) 10^(3) 10^(4)]);

box on;
set(gcf,'color','w');
set(gca,'LineWidth',1.2);
set(gca,'FontSize',30,'TickLabelInterpreter','latex');
tightfig;