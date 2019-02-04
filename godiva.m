%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  godiva
%  ======
%
%  The function used to run the extended GODIVA model. Runs the required 
%  simulation using an ODE solver.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: godiva(length,condition)
%
%         <length> - the length of the simulation in GODIVA time units
%                    (GODIVA2ms in global_parameters sets the ratio between
%                     simulation time units and real time)
%
%         <condition> - what condition to simulate:
%                       'normal' - healthy individual
%                       'DA'     - elevated dopamine levels
%                       'WMF'    - what matter fibers impairment
%
%  Output: sim - the simulation results
%                   sim.output (neural activation over time)
%                   sim.model (the paramaters of model)
%                   sim.time (time steps used)
%
%  Authors:  Oren Civier
%            Jay Bohland
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sim = godiva(varargin)

global sim;
global X;
global simulation;
simulation = varargin{2};

PLOT_ALL = 1
EULER = 0

% Add some paths to stored representation files
% Place modifications into the "custom" folder
addpath('defaults','custom');

% Initialize the necessary model elements
model_msg('Initializing the GODIVA model');
X = struct('IFS',[],'BG_loop',[],'SSM',[],'N',0,'INPUT',[]);

% Set up the inputs to the model
X.INPUT = zeros(53,7,3)
X.NOISE = 0.0;   % standard deviation of noise to be used 
X.TIME = [0:0.01:varargin{1}]; % arbitrary time units -- the length of the simulation
N_SSM = 300; % Number of Speech Sound Map well-learned motor programs (changed from 500 in the oiriginal GODIVA model)

[X.IFS, X.N] = new_IFS(X.N);            % Load up IFS layers
[X.preSMA, X.N] = new_preSMA(X.N);      % Load the preSMA layers
[X.BG_loop_plan, X.N] = new_BG_loop(X.N,'plan');    % Load the "planning" BG loop
[X.SSM, X.N] = new_SSM(X.N,N_SSM);      % Load the speech sound map
[X.SMA, X.N] = new_SMA(X.N);            % Load the SMA layers
[X.BG_loop_motor, X.N] = new_BG_loop(X.N,'motor');    % Load the "motor" BG loop

model_msg(sprintf('A total of %d cells have been instantiated',X.N));

model_msg('Setting up model connectivity');
X.W_IFSp2IFSp = set_IFSp2IFSp_weights(X.IFS.IFSp); % Lateral inhibition in IFS planning layer
X.W_ifs2ssm = set_IFS2SSM_weights([char(X.IFS.IFSp.symbol)]',X.SSM.SSMp.symbol,X.SSM.SSMp.PARAM.N);
size(X.W_ifs2ssm);

X.sylmatch = zeros(N_SSM,1);
X.sylmatch(strmatch('CCV',X.SSM.SSMo.CV_struct(1:N_SSM),'exact')) = 1; 

% Set up the ODE solver parameters etc.
options = [];

icond = zeros(1,X.N);

% This call does the numerical integration and, hence, all the work
% X gets passed as an argument to the update functions - contains current
% state information

tic;
if (X.NOISE > 1) || (EULER),
    model_msg('Using Euler Method');
    [T,P] = ode12(@godiva_update,[X.TIME(1) X.TIME(end)],0.005,[icond],options,X);
else
    model_msg('Using ode23 (for now)');
    [T,P] = ode23(@godiva_update,[X.TIME],[icond],options,X);
end;
toc;

% Return everything for now
sim.output = P;
sim.model = X;
sim.time = T;

% set a nice default colororder
set(0,'DefaultAxesColorOrder',[         0         0    1.0000; ...
         0    0.5000         0; ...
    1.0000         0         0; ...
         0    0.7500    0.7500; ...
    0.7500         0    0.7500; ...
    0.7500    0.7500         0;]);

% plot the results
plot_extended;

end