
% This code generates the PDF's of the real part of the first component of 
% the vorticity field, evaluated  at a fixed large scale wave vector
% k_* = (\lambda,1,1)  and at two different instants of time, 
% t_1=0.075 (before Euler's blowup) and $t_2=0.2$ (after Euler's blowup). 
% And for three differents Reynolds numbers in the set
%
% Res={10^3,10^4,10^5};

% nt = 1 correspond to the time t1 = 0.075 (before Euler's blowup), and
% nt = 2 correspond to the time t2 = 0.2  (after Euler's blowup).

nt=1;

%--------

Res=[10^3,10^4,10^5];

figure;
hold on;
box on;

kx=2; ky=1; kz=1; % correspond to the wave vector k_*=(\lambda,1,1)
C{1}=[0 1 0]; %  verde
C{2}=[1 0 0]; %  Rojo
C{3}=[0 0 1]; %  Azul

for i=1:3
    Re=Res(i);
    dirname = ['Regular_IC_Data/PDF/Re=',num2str(Re),'/'];
    str1=['w_t',num2str(nt),'.mat'];
    load([dirname,str1],'W');

    H=histogram(real(W),'Normalization','pdf','LineWidth',2,'EdgeColor',C{i},'DisplayStyle','stairs');
    set(gca, 'YScale', 'log');
    
    if nt == 1
        axis([-1.5*1e-6 1.5*1e-6 10^(4.8) 10^(7.5)]);
        H.BinWidth=2*10^(-8);
        yticks([10^(5) 10^(6) 10^(7)])
    else
        H.BinWidth=10^(-1);
        axis([-3.9 3.9 0 10^(0)]);
        yticks([10^(-3) 10^(-2) 10^(-1) 10^0])
    end
end

set(gcf,'color','w');
set(gca,'LineWidth',1.2);
set(gca,'FontSize',30,'TickLabelInterpreter','latex');
tightfig;



