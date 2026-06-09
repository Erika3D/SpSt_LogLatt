
function winit = IC_Irregular(rot,Knorm,Kx,Ky,Kz)

% Generates an irregular incompressible initial condition for the vorticity
% field. 

% The construction starts from a velocity field with
% Fourier amplitudes scaling as |u(k)| ~ |k|^{-1/2} and a non-periodic
% phase
%
%     phi(k) = sqrt(2) k_x + sqrt(3) k_y + sqrt(5) k_z.
%
% The irrational coefficients introduce highly oscillatory phases that
% break lattice symmetries and produce a spatially irregular velocity
% field.
%
% The third velocity component is determined from the incompressibility
% condition


% non-periodic phase
phi = sqrt(2)*Kx + sqrt(3)*Ky + sqrt(5)*Kz;

% Velocity components with the spectrum scaling as |u(k)| ~ |k|^{-1/2}.
u0_1 = exp(1i*phi).*Knorm.^(-1/2);
u0_2 = exp(1i*phi).*Knorm.^(-1/2); 

% The third velocity component is determined from the incompressibility
% condition.
u0_3 = -((Kx.*u0_1+Ky.*u0_2)./Kz);

% Assemble the velocity vector field.
uinit(:,:,:,:,1) = u0_1;
uinit(:,:,:,:,2) = u0_2;
uinit(:,:,:,:,3) = u0_3;

winit=rot(uinit);
end
