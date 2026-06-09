
function dwdt = RHS_Euler3D(w,product,grad,rot_,N)

% Computes the right-hand side of the three-dimensional incompressible
% Euler equations in vorticity form,
%
%     dω/dt = (ω · ∇)u - (u · ∇)ω,
%
% where ω is the vorticity field and u is the velocity field obtained
% from ω through the Biot-Savart operator.

    u = rot_(w); % compute velocities from vorticity
    Ju=Jacobian(u,grad,N);
    Jw=Jacobian(w,grad,N);
    dwdti=zeros(N,N,N,4);
    dwdt=zeros(N,N,N,4,3);
    for i=1:3
        for j=1:3
            dwdti=dwdti+product(w(:,:,:,:,j),Ju(:,:,:,:,i,j))-product(u(:,:,:,:,j),Jw(:,:,:,:,i,j));  
        end
        dwdt(:,:,:,:,i)=dwdti;
        dwdti=0;
    end
end

function Jf=Jacobian(f,grad,N) %jacobiano de una funcion f=(f_1,f_2,f_3) donde f(N,N,N,4,3)
% Computes the Jacobian matrix of a vector field
%
%     f = (f1,f2,f3),
%
% returning
%
%              ∂f_i
%     Jf_ij = -------
%              ∂k_j
%
% The output array has dimensions
%
%     (N,N,N,4,3,3),
%
% where the fifth index corresponds to the vector component i
% and the sixth index corresponds to the derivative direction j.

    Jf=zeros(N,N,N,4,3,3);
    f1=f(:,:,:,:,1);
    f2=f(:,:,:,:,2);
    f3=f(:,:,:,:,3);
    grad_f1=grad(f1);
    grad_f2=grad(f2);
    grad_f3=grad(f3);
    for jj=1:3
        Jf(:,:,:,:,1,jj)=grad_f1(:,:,:,:,jj);
        Jf(:,:,:,:,2,jj)=grad_f2(:,:,:,:,jj);
        Jf(:,:,:,:,3,jj)=grad_f3(:,:,:,:,jj);
    end
end