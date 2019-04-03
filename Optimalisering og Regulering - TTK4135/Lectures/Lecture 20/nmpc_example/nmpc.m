% Fairly minimal NMPC example controlling the Van der Pol oscillator with 
% state feedback and single input. Simple warm start of SQP in fmincon 
% using previous solution. The equality constraints representing the 
% nonlinear dynamic system are implemented in VanDerPol.m.
% 
% Tor Aksel N. Heirung, April 2013. 

clc;
clear variables;

% Set length of simulation
n_sim = 120;

% Set lenght of time horizon in the open-loop optimizatin problem. The
% control performance is sensitive to the value of N.
N = 10; % Stable for N = 40 (also 30...)

% Initial value for the states
x0 = [2.2  3.8]';

T = 0.1; % Sampling time of continuous-time system
e = 1.0; % Van der Pol constant
params = struct('T', T,  'e', e,  'xt', x0);

% The number of states and controls
nx = 2;
nu = 1;

% Initialize state and control vectors
x = NaN(nx,n_sim);
x(:,1) = x0;
u = NaN(nu,n_sim);
t_sim = 1:n_sim;

% Initialize figures
f1 = figure(1); clf(f1);
f1_s1 = subplot(2,1,1); 
f1_s2 = subplot(2,1,2);
f2 = figure(2); clf(f2);
f2_s1 = subplot(2,1,1); 
f2_s2 = subplot(2,1,2);
f3 = figure(3); clf(f3);
f3_s = subplot(1,1,1);

% Optimization problem:
% min  1/2 sum_t (1/2){Q_t*x_{t+1}^2 + R_t*u_t^2}
% s.t. x_{t+1} = g(x_t, u_t)
%      x_low <= x_t <= x_high
%      u_low <= u_t <= u_high
Q_t = diag([2 2]);
R_t = 10;
x_low  = [-5; -5];
x_high = [ 5;  5];
u_low  =  -1;
u_high =   1;

% Objective function
I_N = eye(N);
Q = kron(I_N, 2*Q_t);
R = kron(I_N, 2*R_t);
G = blkdiag(Q, R);
f = @(z) z'*G*z; % Objective fucntion handle passed to fmincon

% Inequality constraint, z_lb <= z <= z_ub
x_lb = kron(ones(N,1),x_low);     % Lower bound on x
x_ub = kron(ones(N,1),x_high);    % Upper bound on x
u_lb = kron(ones(N,1),u_low);     % Lower bound on u
u_ub = kron(ones(N,1),u_high);    % Upper bound on u
z_lb = [x_lb; u_lb];              % Lower bound on z
z_ub = [x_ub; u_ub];              % Upper bound on z

% Generate feasible starting point (_sp) by simulating with u = -2*x_2
x_sp = NaN(2,N);
u_sp = zeros(1,N);
x_sp(:,1) = x0;
for k = 1:N
    u_sp(k) = -2*x_sp(2,k);
    x_sp(:,k+1) = [ x_sp(1,k) + T*x_sp(2,k) ;
                    x_sp(2,k) - T*x_sp(1,k) + T*e*(1-x_sp(1,k)^2)*x_sp(2,k) + T*u_sp(k)];
end
x_tp1_Np1 = x_sp(:,2:N+1); % Excludes first time step
z0 = [x_tp1_Np1(:); u_sp(:)]; % Gather x and u in z
params.xt = x0; % Updata parameter struct

% SQP solver options
options = optimoptions('fmincon','Algorithm','sqp-legacy', 'Display','notify', 'Diagnostics','off');

% Vector to store how long it takes fmincon to find the solution at each
% time step
t_solve = NaN(1,n_sim);

% Start a waitbar to show how far the simulation has progressed
h_wbar = waitbar(0,'Simulating with NMPC');

% Simulation loop with NMPC
for t = 1:n_sim
    
    waitbar(t/n_sim); % Update waitbar
    
    % Solving the equality- and inequality-constrained NLP with fmincon.
    % The syntax @(z)VanDerPol(z,params) is used since we need to pass
    % parameters to VanDerPol.m.
    tic; % Start timer 
    [z,fval,exitflag,output,lambda] = fmincon(f,z0,[],[],[],[],z_lb,z_ub,@(z)VanDerPol(z,params),options);
    t_solve(t) = toc; % Stop timer and store elapsed time
    
    % Extracting variables
    x_predicted_vector = z(1:N*nx)';
    x_predicted = reshape(x_predicted_vector, nx, N);
    u_openloop = z(N*nx+1:end)';
    
    % The control we will send to the plant is element 1 of u_openloop
    u_t = u_openloop(1); 
    
    % Simulate one step ahead
    u(:,t) = u_t; % Use first control component
    x(:,t+1) = [ x(1,t) + T*x(2,t) ;
                 x(2,t) - T*x(1,t) + T*e*(1-x(1,t)^2)*x(2,t) + T*u(t)];
    
    % Update equality constraint with new initial condition for x
    params.xt = x(:,t+1);
    
    % We now make a new guess of the next solution z, we call the guess z0.
    % If this guess is good we will find the next solution faster.
    x_sp(:,1) = x(:,t+1); % _sp = starting point. First element is latest measuerment x_{t+1}
                          % We could not have done this here in a real setting.
    u_sp = u_openloop; % Use last open-loop control for the guess z0
    % Find a trajectory x_sp based on the last open-loop control by simulating
    for k = 1:N
        x_sp(:,k+1) = [ x_sp(1,k) + T*x_sp(2,k) ;
                        x_sp(2,k) - T*x_sp(1,k) + T*e*(1-x_sp(1,k)^2)*x_sp(2,k) + T*u_sp(k)];
    end
    x_tp1_Np1 = x_sp(:,2:N+1); % excludes first time step
    z0 = [x_tp1_Np1(:); u_sp(:)];  % Gather the guesses of x and u in z0
    
    % Plot at every iteration. This is not a very good way of updating
    % plots in a loop.
    
    % Plot openloop solution
    plot(f1_s1, t-1:N+t-1, [x(:,t), x_predicted]); xlim(f1_s1, [0,N+n_sim]); ylim(f1_s1, [min(x_low), max(x_high)]); 
    stairs(f1_s2, t-1:N+t-2, u_openloop); ylim(f1_s2, [u_low, u_high]); xlim(f1_s2, [0,N+n_sim]); hold(f1_s2,'on');
    ylim(f1_s2, [u_low, u_high]);
    plot(f1_s2, [t-1,t], [u_t, u_t], 'r', 'LineWidth', 2); hold(f1_s2,'off'); legend(f1_s1, 'x_1', 'x_2');
    title(f1_s1, 'Open-loop solution'); ylabel(f1_s1, 'x'); ylabel(f1_s2, 'u');
    
    % Plot simulation
    plot(f2_s1, t_sim, x(:,t_sim)); xlim(f2_s1, [1,n_sim]); ylim(f2_s1, [min(x_low), max(x_high)]); 
    stairs(f2_s2, t_sim, u); ylim(f2_s2, [u_low, u_high]); hold(f2_s2,'on');
    xlim(f2_s2, [1,n_sim]);
    plot(f2_s2, [t,t+1], [u_t, u_t], 'r', 'LineWidth', 2); hold(f2_s2,'off'); legend(f2_s1, 'x_1', 'x_2');
    title(f2_s1, 'Simulation'); ylabel(f2_s1, 'x'); ylabel(f2_s2, 'u');
    
    % Plot ohase plane
    plot(f3_s,x(1,1:t), x(2,1:t), 'linewidth', 2); box('on'); hold(f3_s,'on');
    plot(f3_s,x0(1), x0(2), 'o', 'linewidth', 2);
    grid(f3_s,'on'); hold(f3_s,'off');
    axis(f3_s,[-3, 3, -3, 4]); title(f3_s, 'Phase portrait');
    xlabel(f3_s,'x_1'); ylabel(f3_s,'x_2');
    
    % Make sure plots are updated at each iteration
    drawnow;
    
end

% Close the waitbar when the simulation is over
close(h_wbar);

% Plot a bar graph with fmincon solution times
figure(4); clf;
bar(1:n_sim, t_solve);
title('fmincon solution time');
xlabel('Solution number t');
ylabel('Time in seconds');
xlim([0,n_sim+1]);
