
% This script gathers the output of all individual simulations
% corresponding to Regular initial condition with a fixed Reynolds number and stores the selected
% observables in a single file.
%
% The aggregated data are saved in
%
%     Data/Regular_IC/PDF/Re=
%
% Inputs:
%
%   Re      : Reynolds number.
%   nseedi  : smallest random seed used in the simulations.
%   nseedf  : largest random seed used in the simulations.
%
% The script assumes that simulation results are available for all
%
%     nseed = nseedi : nseedf.
%

Re =  10^3;
nseedi = 1;
nseedf = 10;

dirname = ['Outputs_PDF/Regular_IC/Re=',num2str(Re),'/'];

% Counter for successfully processed simulations.
nS = 0;

for nSim = nseedi:nseedf

    nS = nS + 1;

    % Load observables extracted from simulation nSim.
    load([dirname,'Sim_',num2str(nSim),'/w_t.mat'])

    % Store the values corresponding to the selected Fourier mode and for
    % the times t1=0.075 and t2=0.2.
    W1(nS) = w1;
    W2(nS) = w2;

end

%% Save aggregated datasets

gdirname = ['Data/Regular_IC/PDF/Re=',num2str(Re),'/'];
if ~exist(gdirname,'dir')
    mkdir(gdirname);  
end


% Data at the first observation time.
W = W1;
save([gdirname,'w_t1.mat'],'W')

% Data at the final observation time.
W = W2;
save([gdirname,'w_t2.mat'],'W')