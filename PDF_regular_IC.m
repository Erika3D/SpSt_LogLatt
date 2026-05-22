% This script generates the figure 4, the PDFs of the real part of the first component of
% the vorticity field,
%
%       Re[omega_1(k_*,t)],
%
% evaluated at the fixed large-scale wave vector
%
%       k_* = (lambda,1,1).
%
% The statistics are analyzed at two different times:
%
%       t_1 = 0.075, before the Euler blowup,
%       t_2 = 0.2,   after the Euler blowup.
%
% The PDFs are computed for three Reynolds numbers:
%
%       Re = 10^3, 10^4, 10^5.

% Create a new figure window and define its position and size.
% The vector [50 500 1500 500] specifies
%
%       [left bottom width height].

% A wide figure is used because the output contains two panels side by side.
figure('Position',[50 500 1500 500]);

% Reynolds numbers used in the simulations.
Res = [10^3,10^4,10^5];

% Indices of the fixed large-scale wave vector k_* = (lambda,1,1).
kx = 2; ky = 1; kz = 1;

% Colors used to distinguish the different Reynolds numbers.
C{1} = [0 1 0];   % green, used for Re = 10^3
C{2} = [1 0 0];   % red, used for Re = 10^4
C{3} = [0 0 1];   % blue, used for Re = 10^5

% Loop over the two times:
%   nt = 1: before Euler blowup,
%   nt = 2: after Euler blowup.
for nt=1:2

    % Create the subplot corresponding to the current time.
    % The first panel shows t_1, and the second panel shows t_2.
    ax = subplot(1,2,nt);

    % Loop over the Reynolds numbers.
    for i=1:3
        
        Re=Res(i); % Select the current Reynolds number.

        % Construct the folder name containing the PDF data for this Re.
        dirname = ['Data/Regular_IC/PDF/Re=',num2str(Re),'/'];
        str1=['w_t',num2str(nt),'.mat'];

        % Load the variable W, which contains the samples of the vorticity
        % mode omega_1(k_*,t) at the selected time and Reynolds number.
        load([dirname,str1],'W');

        % Plot the normalized histogram of the real part of W.
        % The option 'Normalization','pdf' makes the histogram approximate
        % a probability density function.
        %
        % The option 'DisplayStyle','stairs' plots only the outline of the
        % histogram, which makes it easier to compare several PDFs in the
        % same panel.
        H=histogram(real(W),'Normalization','pdf','LineWidth',2,'EdgeColor',C{i},'DisplayStyle','stairs');
        
        % Use a logarithmic scale in the vertical axis. This is useful
        % because the PDF values may vary over several orders of magnitude.
        set(gca, 'YScale', 'log');
        hold on; box on;
        
        % -----------------------------------------------------------------
        % Panel (a): statistics before Euler blowup.
        % -----------------------------------------------------------------
      
        if nt == 1

            % Label the horizontal axis with the random variable evaluated
            % at time t_1.
            xlabel('$\mathcal{R}e[\omega_1(k_*,t_1)]$','Interpreter','latex')
            ylabel('PDF')% Label the vertical axis.
            title('(a)','Interpreter','latex');  % Add the panel label.
            axis([-1.5*1e-6 1.5*1e-6 10^(4.8) 10^(7.5)]); % Set the axis limits for the first time.

            % Choose a small bin width adapted to the narrow distribution.
            H.BinWidth=2*10^(-8); 
            yticks([10^(5) 10^(6) 10^(7)]) % Set the y-axis ticks.

            % Store the position of the first panel.
            axp = ax.Position;
            
            % Create dummy plot handles for the legend.
            % This avoids using the histogram objects directly and gives
            % cleaner legend entries.
            hl1 = plot(nan, nan,'Color',C{1}, 'LineWidth', 1.5);
            hl2 = plot(nan, nan,'Color',C{2}, 'LineWidth', 1.5);
            hl3 = plot(nan, nan,'Color',C{3}, 'LineWidth', 1.5);

            % Add the legend identifying each Reynolds number.
            legend([hl1,hl2,hl3],'$Re = 10^3$','$Re= 10^4$','$Re= 10^5$','FontSize',23,'Location','northwest','Interpreter','latex')

        % -----------------------------------------------------------------
        % Panel (b): statistics after Euler blowup.
        % -----------------------------------------------------------------   
        else

            % Label the horizontal axis with the random variable evaluated
            % at time t_2.
            xlabel('$\mathcal{R}e[\omega_1(k_*,t_2)]$','Interpreter','latex')
            title('(b)','Interpreter','latex'); % Add the panel label.

            % Choose a larger bin width because, after blowup.
            H.BinWidth=10^(-1);

            % Set the axis limits for the second time.
            axis([-3.9 3.9 0 10^(0)]); 

            % Set the y-axis ticks in logarithmic scale.
            yticks([10^(-3) 10^(-2) 10^(-1) 10^0])

            % Shift the second panel slightly to the right to improve the
            % spacing between the two subplots.
            ax.Position = axp + [0.425 0 0 0];
        end
    end

    % Apply common formatting to both panels.
    set(gcf,'color','w'); % white background
    set(gca,'LineWidth',1.2); % thicker axes
    set(gca,'FontSize',23,'TickLabelInterpreter','latex');
end

% Adjust the figure margins to remove unnecessary white space.
tightfig;


