

%  This code generates the PDF (in the Figure 2) of the real part of the first component of
%  the vorticity field, evaluated at a fixed large scale wave vector  k_* = (\lambda,1,1) 
%  and time t_*=0.1, for different values of Reynolds numbers in the set
%
%  Res = [100, 200, 500, 1000, 2000]
%
%  and dimensionless temperature \theta in the set
%
%  Thetas = {1e-6, 1e-8, 1e-10}. 

Thetas=[1e-6, 1e-8, 1e-10];
Res = [100, 200, 500, 1000, 2000];

% Select the value of Re that you want plot:

Re = Res(1);  %  Re selected from the predefined set Res = [100, 200, 500, 1000, 2000]
       
% Plot the PDF's for the value of Re and for the differents values of theta:
for th=1:3
theta = Thetas(th);  %  theta is selected from the predefined set Thetas = [1e-6, 1e-8, 1e-10] 

dirname = ['Irregular_IC_Data/Re=',num2str(Re),'_theta=',num2str(theta),'.mat'];
load(dirname,'W');

fig_name = ['Re = ', num2str(Re), ', theta = ', num2str(theta)];
figure('Name', fig_name, 'NumberTitle', 'off');

H=histogram(real(W),'Normalization','pdf');  
H.BinWidth = 0.04;

if Re == 100 || Re == 200
    axis([-2  0.5 0 25]) % For Re=10^2 and Re=2*10^2
else
    axis([-2  0.5 0 2])  % For Re in {5*10^2,10^3, 2*10^3}
end

xlabel='real(w)';
ylabel = 'PDF(real(w))' ;
set(gcf,'color','w');
set(gca,'LineWidth',1.2);
set(gca,'FontSize',30,'TickLabelInterpreter','latex');
tightfig;
end

