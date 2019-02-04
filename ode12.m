function [tout,yout]=ode12(odefile,tspan,dt,y0,options,varargin)

%function [tout,yout]=ode12(odefile,tspan,dt,y0,options,varargin)
% Explicit Euler method with a fixed time step dt which is prescribed.
% Argument list otherwise matches up with ode23 call.
% No checks for bad arguments.

fprintf('HELLO!');
disp(varargin)

tsteps=ceil(tspan(2)-tspan(1))/dt;
% you might integrate past the given time.

syssize=length(y0);

[y0,shifts]=shiftdim(y0);
% this guarantees that y0 is a column vector.

yout=zeros(tsteps+1,syssize);

yout(1,:)=y0';

tout=[0:tsteps]'*dt;    % a column vector of output times.

y=y0;    % a column vector

for i=2:tsteps+1
    y=y+dt*feval(odefile,tout(i-1),y,varargin{1});
    yout(i,:)=y';
end