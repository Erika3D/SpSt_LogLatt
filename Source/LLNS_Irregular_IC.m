
function LLNS_Irregular_IC(Re,theta,nseed)
% Solver for the three-dimensional Landau–Lifshitz Navier–Stokes (LLNS)
% equations with Irregular initial condition on the golden logarithmic lattice.
%
% The equations are evolved in vorticity form,
%
%     dω = [(ω·∇)u - (u·∇)ω + (1/Re)Δω]dt + dW,
%
% where dW is a stochastic forcing representing thermal fluctuations.
%
% The nonlinear Euler term is integrated using the Runge–Kutta 4(5) method,
% the stochastic contribution is solved using the Euler–Maruyama scheme 
% and the viscous term is treated through an low-pass filter.

% Initialize the random number generator to ensure reproducibility.
rng(nseed);

%% Numerical parameters
% The spectral truncation N and time step h were calibrated for each
% Reynolds number to ensure numerical stability and sufficient spectral
% resolution.
switch Re
    
    case 1e2
        N  = 17; h = 1e-3/2^3;

    case {2e2, 5e2, 1e3}
        N  = 20; h = 1e-3/2^4;

    case 2e3
        N  = 25; h = 1e-3/2^7;

    otherwise
        error(['Unsupported Reynolds number. ', ...
       'If a larger Reynolds number is required, the spectral ', ...
       'truncation parameter N and the time step h must be ', ...
       'recalibrated to ensure numerical accuracy and stability.']);

end

%% Logarithmic lattice operators
product = LogLatt3D_product(N,'golden'); % product on the logarithmic lattice
[dx,dy,dz,~,~,grad,~,rot,rot_] = LogLatt3D_diff(N,'golden'); % differential operators
[Kx,Ky,Kz,Knorm] = LogLatt3D(N,'golden'); % components of the lattice

% Directory where the simulation output will be stored.
dirname = ['Outputs_PDF/Irregular_IC/Re=',num2str(Re),'_theta=',num2str(theta),'/Sim_',num2str(nseed),'/']; 
if ~exist(dirname,'dir')
    mkdir(dirname);  
end

%% Initial condition
winit = IC_Irregular(rot,Knorm,Kx,Ky,Kz); % Generate the initial vorticity field.

%% Right-hand side of the Euler equations
f = @(t,w) RHS_Euler3D(w,product,grad,rot_,N);

%% Fluctuation amplitude.
g = sqrt(theta/Re);

%% Exponential low-pass filter
A = exp(-(1/Re)*Knorm.^2*h);


%% Time integration parameters
T = 0:h:0.1; % Time interval and fixed time-step size.t = 0; % Initial time.
wn = winit; % Initial vorticity field
t=0;

%% Time integration loop
for nk=2:length(T)
    
    [w_new,~]=RKF45_nStep(wn,t,h,f);  % Runge–Kutta–Fehlberg for the nonlinear term.
    dW=White_Noise; % Generate the stochastic forcing.
    wtemp = w_new + g*dW; % Euler–Maruyama for the stochastic contribution.
    wn = A.*wtemp;    % Split step  
    t=t+h;

end

% Save first component of the vorticity field, evaluated at a fixed 
% large-scale wave vector (\lambda,1,1) and a the fixed time t = 0.2.
w = real(wn(2,1,1,1,1));
save([dirname,'w_ft.mat'],'w','t');

function dW = White_Noise
% Generate one realization of the stochastic forcing.

% 1) Generate the six independent components of a complex Gaussian
% symmetric tensor field \tilde{Z}_{ij}.  

Z_11 = randn(N,N,N,4) + 1i*randn(N,N,N,4);
Z_12 = randn(N,N,N,4) + 1i*randn(N,N,N,4);
Z_13 = randn(N,N,N,4) + 1i*randn(N,N,N,4);
Z_22 = randn(N,N,N,4) + 1i*randn(N,N,N,4);
Z_23 = randn(N,N,N,4) + 1i*randn(N,N,N,4);
Z_33 = randn(N,N,N,4) + 1i*randn(N,N,N,4);

% 2) We compute the instantaneous-pointwise trace 

Tr = Z_11 + Z_22 + Z_33;

% 3) We define the off diagonal Zij=Z_ij for i \neq j

Z12 = Z_12;
Z13 = Z_13;
Z21 = Z_12;
Z23 = Z_23;
Z31 = Z_13;
Z32 = Z_23;

% 4) We Redife the diagonal terms to get zero trace and rescale the
% variance

Z11 = sqrt(2)*(Z_11-Tr/3);
Z22 = sqrt(2)*(Z_22-Tr/3);
Z33 = sqrt(2)*(Z_33-Tr/3);

% Compute div(Z)
Z=zeros(N,N,N,4,3);

Z(:,:,:,:,1)=dx(Z11) + dy(Z12) + dz(Z13);
Z(:,:,:,:,2)=dx(Z21) + dy(Z22) + dz(Z23);
Z(:,:,:,:,3)=dx(Z31) + dy(Z32) + dz(Z33);

% Apply the curl operator and multiply by sqrt(h) to obtain the
% Wiener increment used in the Euler–Maruyama update.

dW=sqrt(h)*rot(Z);
end
end

