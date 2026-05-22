%  This script generates the PDFs shown in Figure 2.
%
% We analyze the real part of the first component of the vorticity field,
% evaluated at the fixed large-scale wave vector
%   
%       k_* = (\lambda,1,1) 
%
%  and at the fixed time t_*=0.1.
%
% The goal is to compare the statistics of this large-scale Fourier mode
% for several Reynolds numbers and different values of the dimensionless
% temperature theta.
%
% The Reynolds numbers considered are
%
%  Res = [100, 200, 500, 1000, 2000],
%
% while the values of the dimensionless temperature are
%
%  Thetas = {1e-6, 1e-8, 1e-10}.
%
% Each subplot displays a normalized histogram, obtained from the numerical samples
% stored in the corresponding data file.
%
% The rows correspond to increasing Reynolds numbers, emphasizing the
% limit Re -> infinity. The columns correspond to decreasing values of
% theta, emphasizing the zero-noise limit theta -> 0.
%
% For the largest Reynolds number, a Gaussian density with the same mean
% and standard deviation as the numerical data is also plotted for comparison.


Thetas=[1e-10, 1e-8, 1e-6]; % Values of the dimensionless temperature theta used in the simulations.
Res = [100, 200, 500, 1000, 2000]; % Reynolds numbers used to study the approach to the inviscid limit.

% Create a new figure window and define its position and size.
% The vector [1000 1000 1100 1500] specifies:
%   [left bottom width height]
% where width and height are chosen large enough to display a 5-by-3 panel figure.
figure('Position',[1000 1000 1100 1500]); 

n=0; % Counter used to number the subplots sequentially.

% Desired spacing and margins for the manual subplot layout.
% These values are given in normalized figure coordinates.
hspace = 0.0385;   % vertical space between rows of subplots
wspace = 0.04;     % horizontal space between columns of subplots
top = 0.93;        % upper margin of the panel
left = 0.065;      % left margin of the panel
bottom = 0.051;    % lower margin of the panel
right = 0.92;      % right margin of the panel

% Compute the width and height of each subplot.
width  = (right-left - (3-1)*wspace)/3;
height = (top-bottom - (5-1)*hspace)/5;

% Plot the PDFs for each Reynolds number Re and each value of theta.
% The rows (i) correspond to different Reynolds numbers, while the columns
% (j) correspond to different values of the dimensionless temperature theta.
for i=1:5
    for j=1:3
        % Select the Reynolds number and the temperature corresponding
        % to the current row and column.
        Re = Res(i);
        theta = Thetas(j);
        
        n=n+1; % Increase the subplot counter.
        
        % Create the subplot in the default MATLAB position.
        % Its position will be manually adjusted below.
        ax = subplot(5,3,n);
        
        % Construct the name of the file containing the statistical data
        % for the current pair (Re, theta).        
        dirnameEstadistica = ['Data/Irregular_IC/Re=',num2str(Re),'_theta=',num2str(theta),'.mat'];
        
        % Load the variable W from the data file.
        % W contains the samples of the vorticity mode considered here.
        load(dirnameEstadistica,'W');
        
        X=real(W); % Extract the real part of W.
        
        % Plot a normalized histogram of the data.
        % The option 'Normalization','pdf' makes the histogram approximate
        % a probability density function.
        H=histogram(X,'Normalization','pdf');  
        
        % Use the same bin width for all histograms, which allows a fair
        % visual comparison between different values of Re and theta.        
        H.BinWidth = 0.04;

        % Set different vertical axis ranges depending on the Reynolds number.
        % For the first two rows, the PDFs are more concentrated and may reach
        % larger peak values. For the remaining rows, a smaller vertical range
        % makes the broader distributions easier to visualize.
        if i==1 || i==2
            axis([-2  0.5 0 25])
            yticks([0 5 10 15 20 25])
        else
            axis([-2  0.5 0 2])
            yticks([0 0.5 1 1.5 2])
        end
        
        xticks([-2 -1.5 -1 -0.5 0 0.5]);  % Set the same horizontal ticks for all subplots.
        
        % Improve the visual style of the figure.
        set(gcf,'color','w'); % white background           
        set(gca,'LineWidth',1.2); % thicker axes
        set(gca,'FontSize',15,'TickLabelInterpreter','latex'); % LaTeX ticks
        
        % Compute the manual position of the subplot.
        % The position depends on the row index i and the column index j.
        xpos = left + (j-1)*(width+wspace);
        ypos = top - i*height - (i-1)*hspace;
        ax.Position = [xpos ypos width height];  % Assign the manually computed position to the current subplot.
        
        % Add the y-axis label only to the first column to avoid repetition.
        if j == 1
            ylabel('PDF','FontSize',18)
        end
        
        % Add the value of theta on top of each column.
        % This is done only in the first row, since each column corresponds
        % to a fixed value of theta.
        if i == 1
            ylims = ylim; % current y-axis limits
            xlims = xlim; % current x-axis limits
            
            text(mean(xlims), ylims(2), ['$\theta = 10^{',num2str(log10(theta)),'}$'], ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','bottom','Color',[0 0.6 0],'Interpreter','latex','FontSize',23)

        end

        % For the last row, plot a Gaussian density with the same mean and
        % standard deviation as the numerical data. This provides a visual
        % comparison between the empirical PDF and a normal distribution.
        if i==5
            hold on;
            Media = mean(X); Desv = sqrt(cov(X));
            x=min(X):0.01:max(X);
            Y = normpdf(x,Media,Desv);
        
            plot(x,Y,'LineWidth',2)
            xlabel('$\mathcal{R}e[\omega_1(k_*,t_*)]$','Interpreter','latex','FontSize',20)
        end

        
        % Add the Reynolds number label to the right of the last column.
        % Each row corresponds to one fixed Reynolds number.
        if j == 3
            ax = gca;
            ax.YColor = 'k'; 
            
            % Define the Reynolds number label in scientific notation.
            if i==1
                str = '$Re =  10^2$';
            end
            if i==2
                str = '$Re =  2 \cdot 10^2$';
            end
            if i==3
                str = '$Re = 5 \cdot 10^2$';
            end
            if i==4
                str = '$Re = 10^3$';
            end
            if i==5
                str = '$Re = 2 \cdot 10^3$';
            end
            
            % Place the Reynolds number label outside the right edge
            % of the subplot. The coordinates are normalized with respect
            % to the current axes.
            t = text(ax, 1.05, 0.5, str, ...
                'Units','normalized', ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','middle', ...
                'Rotation',270, ...
                'Interpreter','latex', ...
                'FontSize',23, ...
                'Color',[1 0.5 0]);   % naranja
        end

    end
end

% -------------------------------------------------------------------------
% Vertical arrow indicating the direction Re -> infinity.
% -------------------------------------------------------------------------

% Coordinates of the vertical arrow in normalized figure units.
x1 = 0.962;  x2 = x1;    
y1 = 0.93+0.015; % upper end of the arrow
y2 = 0.05-0.015; % lower end of the arrow

h = annotation('arrow', [x1 x2], [y1 y2]); % Draw the vertical arrow.

% Set the visual properties of the arrow.
h.Color = [1 0.5 0];  
h.LineWidth = 9; 
h.HeadLength = 28;
h.HeadWidth  = 28;

% Add an invisible full-figure axis to place text in normalized coordinates.
axes('Position',[0 0 1 1],'Visible','off');

% Add the label Re -> infinity next to the vertical arrow.
text(x1+0.02,0.5,'$Re \to \infty$',...
    'Units','normalized','Interpreter','latex','Rotation',270,...
    'Color',[1 0.5 0],'FontSize',30,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')


% -------------------------------------------------------------------------
% Horizontal arrow indicating the direction theta -> 0.
% -------------------------------------------------------------------------

% Coordinates of the horizontal arrow in normalized figure units.
% The arrow goes from right to left because theta decreases from right to left.
x1 = 0.92+0.02;  % right end of the arrow
x2 = 0.052-0.02; % left end of the arrow
y1 = 0.962; y2 = y1;

h = annotation('arrow', [x1 x2], [y1 y2]); % Draw the horizontal arrow.

% Set the visual properties of the arrow.
h.Color = [0 0.6 0];   % naranja (RGB: [R G B])
h.LineWidth = 9; 
h.HeadLength = 28;
h.HeadWidth  = 28;

% Compute the midpoint of the horizontal arrow.
xm = (x1+x2)/2;
ym = (y1+y2)/2+0.015;


% Add an invisible axis at the midpoint of the arrow to place the text label.
axes('Position',[xm ym 0 0],'Visible','off'); 

% Add the label theta -> 0 above the horizontal arrow.
text(0.5,0.5,'$\theta \to 0$',...
    'Units','normalized','Interpreter','latex','Rotation',0,...
    'Color',[0 0.6 0],'FontSize',30,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')


% Export the figure in EPS format if needed.
% print('ICI','-depsc');
