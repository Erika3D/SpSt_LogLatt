
% Solver for the three-dimensional incompressible Euler equations
% on the golden logarithmic lattice.
%
% The equations are evolved in vorticity form,
%
%     dω/dt = (ω·∇)u - (u·∇)ω,
%
% using an adaptive Runge–Kutta–Fehlberg 4(5) time integrator.
% The velocity field is recovered from the vorticity through the
% Biot–Savart operator implemented on the logarithmic lattice.

% Spectral truncation parameter.
% The logarithmic lattice contains 60 shells, with the highest
% resolved wavenumber given by k_max = lambda^59.
N = 60;

%% Logarithmic lattice operators
product = LogLatt3D_product(N,'golden'); % product on the logarithmic lattice
[~,~,~,~,~,grad,~,rot,rot_] = LogLatt3D_diff(N,'golden'); % differential operators
[l2norm,~,sup] = LogLatt3D_norms;


% Directory where the simulation output will be stored.
dirname = 'Data/Regular_IC/VorticityNorm/'; 

if ~exist(dirname,'dir')
    mkdir(dirname);  % crea la carpeta con el nombre correspondiente a dirnam
end

%% Initial condition
uinit = IC_Regular(N); % Generate the initial velocity field.
winit=rot(uinit); % Convert the initial velocity field into vorticity.

%% Right-hand side
% dw/dt=f(t,w1,w2,w3)
f= @(t,w) RHS_Euler3D(w,product,grad,rot_,N); 

%% Time integration parameters
tolerance = 10e-7; % Relative error tolerance
h=0.1; % Initial time step.

% Initial state.
wn=winit;
t=0;
nStep=1;

% Save initial condition.

Enstrophy(nStep)=0.5*l2norm(wn)^2;  %enstrophy
H(nStep) = h; 
T(nStep) = t;
w_max(nStep) = sup(wn);

%% Time integration loop

% Continue integration until the adaptive step size becomes
% smaller than the prescribed minimum threshold.
while h > 1e-15
    
    % Advance one RKF45 step and estimate the local error.
    [w_new,dw_new]=RKF45_nStep(wn,t,h,f);
    
    % Relative error estimate based on the supremum norm.
    err=sup(dw_new)/sup(w_new); 
    
    if err<=tolerance 
        % Accept the step.
        t = t+h;
        wn=w_new;

        nStep = nStep + 1;
        Enstrophy(nStep)=0.5*l2norm(wn)^2;  %enstrophy
        H(nStep) = h; 
        T(nStep) = t;
        w_max(nStep) = sup(wn);
        
    else
        % Reject the step and reduce the time step.
        h=h/2;
    end
end

% Save the solution at the accepted time.
save([dirname,'Euler.mat'],'Enstrophy','H','T','w_max');