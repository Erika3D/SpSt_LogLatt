
function uinit = IC_Regular(N)

% Regular_IC Generates a regular incompressible initial condition on the logarithmic lattice invariant under certain rotations.
%
% Input:
%   N : logarithmic lattice truncation.
%
% Output:
%   u0 : divergence-free initial velocity field
  
% Generate the wavevector components and their norm on the three-dimensional golden logarithmic lattice.
[Kx,Ky,Kz,Knorm] = LogLatt3D(N,'golden'); % components of the lattice

% Golden ratio used as the scale factor of the lattice.
lambda = (1+sqrt(5))/2;

%% First quadrant

% Construct a regular velocity field with a power-law spectrum
% scaling as |u(k)| ~ k^{-3/2}.

% Recall that vector fields U(Kx,Ky,Kz) are encoded as complex matrices U of size
% N x N x N x nquad x d, where nquad is the quadrant and d is the
% component.

u0=1i*Knorm.^(-3/2)*lambda^10;

us=zeros(N,N,N,4,3);
us(:,:,:,:,1)=u0;
us(:,:,:,:,2)=u0;
us(:,:,:,:,3)=u0;

%% Additional quadrants
% Generate symmetry under certain rotations.
us(:,:,:,2,1)=-us(:,:,:,2,1);%q2
us(:,:,:,3,1:2)=-us(:,:,:,3,1:2);%q3
us(:,:,:,4,2)=-us(:,:,:,4,2); %q4

%% Leray projection

% Project the velocity field onto the divergence-free subspace,
% ensuring incompressibility..

uinit=LP(us,Kx,Ky,Kz,Knorm,N);

function u=LP(f0,Kx,Ky,Kz,Knorm,N)

% Leray projector:
%
% P_ij(k) = delta_ij - k_i*k_j/|k|^2
%
% This removes the velocity component parallel to k and
% guarantees that the projected field satisfies
%
% k · u = 0.
%

K=cell(3,1);

u=zeros(N,N,N,4,3);

dirac=@(a,b) D_Dirac(a,b);

aux1=zeros(N,N,N,4); aux2=zeros(N,N,N,4); aux3=zeros(N,N,N,4);
K{1}=Kx; K{2}=Ky; K{3}=Kz;
for j=1:3
    aux1 = aux1 + (dirac(1,j) - (K{1}.*K{j})./Knorm.^2).*f0(:,:,:,:,j);
    aux2 = aux2 + (dirac(2,j) - (K{2}.*K{j})./Knorm.^2).*f0(:,:,:,:,j);
    aux3 = aux3 + (dirac(3,j) - (K{3}.*K{j})./Knorm.^2).*f0(:,:,:,:,j);
end

u(:,:,:,:,1)=aux1;
u(:,:,:,:,2)=aux2;
u(:,:,:,:,3)=aux3;

end

function d= D_Dirac(a,b)
if a==b 
    d=1;
else
    d=0;
end
end
end

