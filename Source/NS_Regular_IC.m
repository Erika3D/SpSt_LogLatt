
% Solver for the three-dimensional incompressible Navier–Stokes equations
% on the golden logarithmic lattice.
%
% The equations are evolved in vorticity form,
%
%     dω/dt = (ω·∇)u - (u·∇)ω + (1/Re)Δω.
%
% A split-step scheme is employed: the nonlinear Euler dynamics are
% integrated using the adaptive Runge–Kutta–Fehlberg 4(5) method,
% while viscous dissipation is treated exactly through the exponential
% low-pass filter.

N=40; % Truncation cuttof

% Different Reynolds numbers considered in the simulations.
Res = [10^4 10^5 10^6 10^7]; 

% Select the Reynolds number for the current run.
Re = Res(1); %correspond to Re=10^4

%% Logarithmic lattice operators
product = LogLatt3D_product(N,'golden'); % product on the logarithmic lattice
[~,~,~,~,~,grad,~,rot,rot_] = LogLatt3D_diff(N,'golden'); % differential operators
[~,~,~,Knorm] = LogLatt3D(N,'golden'); % components of the lattice
[l2norm,~,sup] = LogLatt3D_norms;


%% Output directory
dirname = 'Data/Regular_IC/VorticityNorm/'; 

if ~exist(dirname,'dir')
    mkdir(dirname);  % crea la carpeta con el nombre correspondiente a dirnam
end

%% Initial condition
uinit = IC_Regular(N); % Generate the initial velocity field.
winit=rot(uinit); % Convert the initial velocity field into vorticity.

%% Time integration 

h = 0.1/2^11; % Fixed time step.
T=0:h:0.2; % Output times.
t=0;
wn = winit;   

%% Right-hand side
% dw/dt=f(t,w1,w2,w3)
f = @(t,w) RHS_Euler3D(w,product,grad,rot_,N);

%% Exponential low-pass filter
A = exp(-(1/Re)*Knorm.^2*h);

% Save initial data.

nStep = 1;
w_max = zeros(length(T),1);

w_max(nStep) = sup(wn);

for k=1:length(T)-1

    [w_new,~]=RKF45_nStep(wn,t,h,f); % Integrate the nonlinear Euler dynamics.
    wn = A.*w_new;  % Split step 

    nStep = nStep + 1;
    w_max(nStep) = sup(wn);

end

% Save the solution at the accepted time.
save([dirname,'Re=',num2str(Re),'.mat'],'h','N','Re','T','w_max');