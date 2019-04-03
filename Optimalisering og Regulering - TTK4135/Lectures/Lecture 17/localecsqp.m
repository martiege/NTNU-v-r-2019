
close all; clear all

% min -x1 - x2 s.t. x1^2 + x2^2 = 1

f = @(x) - x(1) - x(2);  
df = @(x) [-1; -1];

c = @(x) x(1)^2 + x(2)^2 - 1;
A = @(x) [2*x(1), 2*x(2)];

HL = @(x,lambda) diag([- 2*lambda, -2*lambda]);

x0 = [0;1]; lambda0 = -1;
x(:,1) = x0; lambda(1,:) = lambda0;

plot(x(1,1),x(2,1),'rx'); hold on;
syms x1; syms x2;  ezplot((x1).^2+(x2).^2-1); % plot circle
xlim([-1.5,1.5]); ylim([-1.5,1.5]);


for i = 1:10
    [p,fval,exitflag,output,lo] = quadprog(HL(x(:,i),lambda(i)),df(x(:,i))',[],[], A(x(:,i)),-c(x(:,i)));
    l = -lo.eqlin;
    
    % z = [ HL(x(:,i),lambda(i)), -A(x(:,i))'; A(x(:,i)), 0] \ [-df(x(:,i)); -c(x(:,i))];
    % p = z(1:2);
    % l = z(3);
    
    x(:,i+1) = x(:,i) + p;
    lambda(:,i+1) = l;
    
    plot(x(1,i+1),x(2,i+1),'rx');    
end

        