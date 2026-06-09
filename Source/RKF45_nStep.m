
function [w_new,dw_new]=RKF45_nStep(wn,tn,h,f)

% Performs a single time step of the Runge–Kutta–Fehlberg 4(5) method. 

% Input:
%   wn : solution at time tn
%   tn : current time
%   h  : time-step size
%   f  : right-hand side of the ODE, dw/dt = f(t,w)
%
% Output:
%   w_new  : fifth-order approximation at tn+h
%   dw_new : estimate of the local truncation error

%% RKF45 Butcher tableau coefficients
A=[0;1/4;3/8;12/13;1;1/2];
B=zeros(6,5);
B(2,:)=[1/4,0,0,0,0];
B(3,:)=[3/32,9/32,0,0,0];
B(4,:)=[1932/2197,-7200/2197,7296/2197,0,0];
B(5,:)=[439/216,-8,3680/513,-845/4104,0];
B(6,:)=[-8/27,2,-3544/2565,1859/4104,-11/40];

%% Fourth-order weights
C=zeros(6,1);
C(1,:)=25/216;
C(3,:)=1408/2565;
C(4,:)=2197/4104;
C(5,:)=-1/5;

%% Fifth-order weights
CH=zeros(6,1);
CH(1,:)=16/135;
CH(3,:)=6656/12825;
CH(4,:)=28561/56430;
CH(5,:)=-9/50;
CH(6,:)=2/55;

%% Error estimator weights
CT=zeros(6,1);
CT(1,:)=-1/360;
CT(3,:)=128/4275;
CT(4,:)=2197/75240;
CT(5,:)=-1/50;
CT(6,:)=-2/55;

%% Runge-Kutta stages
k1=h*f(tn,wn); 
k2=h*f(tn+A(2)*h,wn+B(2,1)*k1);   
k3=h*f(tn+A(3)*h,wn+B(3,1)*k1+B(3,2)*k2); 
k4=h*f(tn+A(4)*h,wn+B(4,1)*k1+B(4,2)*k2+B(4,3)*k3); 
k5=h*f(tn+A(5)*h,wn+B(5,1)*k1+B(5,2)*k2+B(5,3)*k3+B(5,4)*k4); 
k6=h*f(tn+A(6)*h,wn+B(6,1)*k1+B(6,2)*k2+B(6,3)*k3+B(6,4)*k4+B(6,5)*k5); 

%% Fifth-order solution
w_new=wn+CH(1)*k1+CH(2)*k2+CH(3)*k3+CH(4)*k4+CH(5)*k5+CH(6)*k6;

%% Local error estimate
dw_new=CT(1)*k1+CT(2)*k2+CT(3)*k3+CT(4)*k4+CT(5)*k5+CT(6)*k6;
end
