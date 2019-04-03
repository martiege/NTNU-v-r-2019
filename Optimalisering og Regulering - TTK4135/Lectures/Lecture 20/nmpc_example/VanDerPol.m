function [c,ceq] = VanDerPol(z,params)
% Function implementing the Van der Pol oscillator as equality constraints
% for NMPC with fmincon.
    
    c = []; % No nonlinear inequality constraints

    nx = 2; % Two states
    nu = 1; % One control
    N = numel(z)/(nx+nu); % Time horizon
    
    % Parameters:
    T = params.T; % Sampling time of continuous-time system
    e = params.e; % Van der Pol constant
    xt = params.xt; % Initial value for the states
     
    % Extracting variables in x and u from z
    x = z(1:N*nx);
    u = z(N*nx+1:end);
    % Adding initial conditions (cannot be part of z, would then be treated
    % as variables):
    x1 = [xt(1); x(1:2:end)];
    x2 = [xt(2); x(2:2:end)];
    
    % x(t+1) = g(x_t, u_t) written in the constraint form
    % ceq(z) = -x(t+1) + g(x_t, u_t) = 0
    % Note that the top half of the vector ceq contains the first state
    % equation for all time steps, and that the second half contains the 
    % second state equation for all time steps. The order of the 
    % constraints in ceq does not matter, this ordering is used since it is
    % simple to implement.
    ceq = [ -x1(2:end) + x1(1:end-1) + T*x2(1:end-1) ;
            -x2(2:end) + x2(1:end-1) - T*x1(1:end-1) + T*e*(1-x1(1:end-1).^2).*x2(1:end-1) + T*u(1:end) ];
          
end
