%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  update_SSM
%  ==========
%  Return the momentary change in the cell activations of the SSM
%  (Speech Sound Map).
%  Activated by the ODE solver.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: update_SSM(cur,sim,time)
%
%         cur - current state of the cells necessary to compute the SSM 
%               update. These fields are filled in "godiva_update.m"
%               Note that the potentials are passed through signal functions to get
%               "outputs" of cells
%
%         sim - the parameters of the simulation
%
%         time - time in the simulation
%
%  Output: dx - momentary change in SSM cell activations
%
%  Authors:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = update_SSM(cur,sim,time)

% how fast the planning layer is changing relative to choise layer
PLAN_SPEED = 0.05; 

global SSM_output_suppression;

cur.IFSc = reshape(cur.IFSc,sim.IFS.IFSc.PARAM.SIZE);
cur.IFSc = sum(cur.IFSc,3); % sum along repeats 

% The weight matrix from IFS to SSM is dimension #IFS x #SSM cells.
% includes normalization of inputs
netinput = ((max(0,(cur.IFSc(:)-0.5))').^2 * sim.W_ifs2ssm)';

% each cell inhibits all others
netInh_SSMp = sum(sigf_SSMp(cur.SSMp))-sigf_SSMp(cur.SSMp); 

% update SSM plan cells
dSSMp = -sim.SSM.SSMp.PARAM.A .* cur.SSMp + ...
     PLAN_SPEED .* ( (sim.SSM.SSMp.PARAM.B -cur.SSMp).*(netinput + 0.5*sigf_SSMp(cur.SSMp))  - ...
     cur.SSMp.*(netInh_SSMp) );

netInh = sum(sigf_SSMo(cur.SSMo).*sigf_thal(max(cur.THAL - 9,0)))-sigf_SSMo(cur.SSMo).*sigf_thal(max(cur.THAL - 9,0)); 

E_s = 2;
I = (time>4 & time < 19);

% update SSM choise cells
dSSMo = -sim.SSM.SSMo.PARAM.A*cur.SSMo + ...
     (sim.SSM.SSMo.PARAM.B-cur.SSMo) .* (cur.SSMp ... % plans only prime, not excite choice
    + E_s .*  sigf_thal(max(cur.THAL - 9,0)) .* sigf_SSMo(cur.SSMo)) .* I ... 
     - (cur.SSMo.*(netInh)  + get_DIVAsuppression(time)); 

dx = [dSSMp; dSSMo];

function y = sigf_SSMp(x)
y = max(0,x-0.1);  %0.1 is a noise threshold

function y = sigf_SSMo(x)
y = max(0,(x-0.3)).^1.5; 

function y = sigf_thal(x)
y = x.^4;