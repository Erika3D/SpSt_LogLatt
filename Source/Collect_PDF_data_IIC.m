





% This script gathers the output of all individual simulations
% corresponding to Irregular initial condition with a fixed Reynolds number 
% and thet, and stores the selected observables in a single file.
%
% The aggregated data are saved in
%
%     Data/Irregular_IC/
%
% Inputs:
%
%   Re      : Reynolds number.
%   theta   : dimensionless temperature.
%   nseedi  : smallest random seed used in the simulations.
%   nseedf  : largest random seed used in the simulations.
%
% The script assumes that simulation results are available for all
%
%     nseed = nseedi : nseedf.
%

Re =  10;
theta = 1;
nseedi = 1;
nseedf = 2;

dirname = ['Outputs_PDF/Irregular_IC/Re=',num2str(Re),'_theta=',num2str(theta),'/'];

% Counter for successfully processed simulations.
nS = 0;

for nSim = nseedi:nseedf

    nS = nS + 1;

    % Load observables extracted from simulation nSim.
    load([dirname,'Sim_',num2str(nSim),'/w_ft.mat'])

    % Store the values corresponding to the selected Fourier mode.
    W(nS) = w;

end

%% Save aggregated datasets

gdirname = 'Data/Irregular_IC/';

if ~exist(gdirname,'dir')
    mkdir(gdirname);  
end


% Data at the final observation time.
save([gdirname,'Re=',num2str(Re),'_theta=',num2str(theta),'.mat'],'W')