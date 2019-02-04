%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  update_SMA
%  ==========
%  Return the momentary change in the cell activations of the SMA.
%  Activated by the ODE solver.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: update_SMA(cur,sim,time)
%
%         cur - current state of the cells necessary to compute the IFS 
%               update. These fields are filled in "godiva_update.m"
%               Note that the potentials are passed through signal functions to get
%               "outputs" of cells
%
%         sim - the parameters of the simulation
%
%         time - time in the simulation
%
%  Output: dx - momentary change in SMA cell activations
%
%  Authors:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = update_SMA(cur,sim,time)

% The SMA resentation is #syl_types x #of copies
% These are the *whole syllable frame* cells

% treat each cell totally independently (no relation between same types)
netInh_SMAp = (sum(sigf_p(cur.SMAp)) - sigf_p(cur.SMAp));
netInh_SMAc = (sum(sigf_c(cur.SMAc)) - sigf_c(cur.SMAc));

% update SMA planning cells
dSMAp = -sim.SMA.SMAp.PARAM.A * cur.SMAp + ...
    (sim.SMA.SMAp.PARAM.B - cur.SMAp).*(cur.THAL ./ sim.BG_loop_motor.THAL.PARAM.B .* sigf_p(cur.SMAp) + get_inf_preSMA_gain(time) .* (cur.SSMo) .* 500 ... 
    ) - cur.SMAp .* (netInh_SMAp ... 
    );

sim.SMA.SMAc.PARAM.A = 10; % so there will be a dip in the activation of the choice layer winner

CHOICE_LAYER_BIAS = 2; % how much the influence of THAL is greater for choice than plan layer

% update SMA choice cells
dSMAc = -sim.SMA.SMAc.PARAM.A * cur.SMAc + ...
    (sim.SMA.SMAc.PARAM.B - cur.SMAc) .* ((sigf_p(cur.SMAp-0.5) + CHOICE_LAYER_BIAS .* (cur.THAL ./ sim.BG_loop_motor.THAL.PARAM.B) .* sigf_c(cur.SMAc))) ... 
    - cur.SMAc .* (netInh_SMAc+cur.SMAc);

dx = [dSMAp(:); dSMAc(:)];

% These are directly copied from the IFS layer
function y = sigf_p(x)
y = max(0,x).^1.8;

function y = sigf_c(x)
y = max(0,x).^2;