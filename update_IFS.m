%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  update_IFS
%  ==========
%  Return the momentary change in the cell activations of the IFS.
%  Activated by the ODE solver.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: update_IFS(cur,sim_BG_loop,time)
%
%         cur - current state of the cells necessary to compute the IFS 
%               update. These fields are filled in "godiva_update.m"
%               Note that the potentials are passed through signal functions to get
%               "outputs" of cells
%
%         sim_BG_loop - the parameters of the simulation
%
%         time - time in the simulation
%
%  Output: dx - momentary change in IFS cell activations
%
%  Authors:  Oren Civier
%            Jay Bohland
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = update_IFS(cur,sim,time)


cur.IFSp = reshape(cur.IFSp,sim.IFS.IFSp.PARAM.SIZE);
cur.IFSc = reshape(cur.IFSc,sim.IFS.IFSc.PARAM.SIZE);

% compute the multiplicative gates on thalamus - ignore initial "strange"
% effects

thalGate = zeros(size(cur.IFSc));

if (time > 1),
    thalGate = ones(size(cur.IFSc));  % Gate is always open
end;

% Local functions define the signal functions for these cells
% sigf_p is the signal function for the plan cells
% sigf_c is the signal function for the choice cells

% compute the total inhibitory input to each cell -- do this for one
% #phonemes x #positions layer, then replicate for repeating element
% dimension
netInh_IFSp = (sum(sigf_p(cur.IFSp),3)' *sim.W_IFSp2IFSp)';
netInh_IFSp = repmat(netInh_IFSp,[1,1,sim.IFS.IFSp.PARAM.SIZE(3)]);

netInh_IFSc = (sum(sigf_c2(cur.IFSc),3)' *sim.W_IFSp2IFSp)';
netInh_IFSc = repmat(netInh_IFSc,[1,1,sim.IFS.IFSc.PARAM.SIZE(3)]);

dIFSp = zeros(size(cur.IFSp));
dIFSc = zeros(size(cur.IFSc));

modB = repmat(sim.IFS.IFSp.PARAM.B,size(dIFSp));

% update IFS plan cells
dIFSp = -sim.IFS.IFSp.PARAM.A * cur.IFSp + ...
    (modB - cur.IFSp).*(sigf_p(cur.IFSp)+(0.4*get_InputVector(time))) - ...
    cur.IFSp.*(netInh_IFSp + 10*(max(0,cur.IFSc-3)).^2);

SSM_THRESHOLD = 4;

% threshold the SSM values
cur.SSMo = double( cur.SSMo == max(cur.SSMo) & cur.SSMo > SSM_THRESHOLD ); % ensures that it's also the maximum

weights = double(sim.W_ifs2ssm > 0);
SSMsuppression = weights * cur.SSMo;
SSMsuppression = repmat(reshape(SSMsuppression,[size(cur.IFSc,1),size(cur.IFSc,2)]),[1,1,3]);

% Update IFS choice layer
dIFSc = -sim.IFS.IFSc.PARAM.A * cur.IFSc + ...
     (sim.IFS.IFSc.PARAM.B - cur.IFSc).*(sigf_p(cur.IFSp-0.5).*thalGate + (sigf_c2(cur.IFSc))) - ...
     cur.IFSc.*(netInh_IFSc + 15*SSMsuppression);
 
 dx = [dIFSp(:); dIFSc(:)];


% Define the neuron signal functions for the cells in this layer
% Signal function for IFS planning layer
function y = sigf_p(x)
y = max(0,(x-0.01));

% Signal function for IFS choice layer
function y = sigf_c(x)
y = max(0,(x-0.5)).^2;

function y = sigf_c2(x)
y = max(0,(x)).^2;

