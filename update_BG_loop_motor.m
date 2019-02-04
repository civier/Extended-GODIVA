%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  update_BG_loop_motor
%  ====================
%
%  Return the momentary change in the cell activations of the BG-vPMC loop.
%  Activated by ODF soler.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: update_BG_loop_motor(cur,sim_BG_loop,time)
%
%         cur - current state of the cells necessary to compute the IFS 
%               update. These fields are filled in "godiva_update.m"
%               Note that the potentials are passed through signal functions to get
%               "outputs" of cells
%
%         sim_BG_loop - the parameters of the BG-vPMC loop cells
%
%         time - time in the simulation
%
%  Output: dx - momentary change in BG-vPMC cell activations
%
%  Notes: 1) In contract with original GODIVA version, many components
%            of the BG-vPMC loop do not have self decay.
%         2) Thalamus implementation is completely different:
%               a) Thalamus excited directly by plan cells
%               b) Thalamus has self-excitation
%               c) Thalamus had no self-decay
%
%  Author:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = update_BG_loop_motor(cur,sim_BG_loop,time) % pass the correct simulation parameters

% load global parameters
global_parameters;

% inhibition in striatum through fast spiking inter-neurons
STR_netInh = sum(fbfunC(cur.CORTEXp))-fbfunC(cur.CORTEXp); % FS-IN are not simulated, instead, inhibition is directly from cortex

% update striatum cells, direct pathway
dSTR = -sim_BG_loop.STR.PARAM.A*cur.STR  ... % decay not in Brown et al. (2004), but included in Bohland et al. (2010)
     + (beta_D1.*sim_BG_loop.STR.PARAM.B - cur.STR).* cur.CORTEXp ...   
     - cur.STR.*(STR_netInh);   % surround inhibition to improve contrast using inhibitiory FS-IN
     
% Brown et al. (2004) model BG influence by multiplying the input by N_tilda, where
% N_tilda is a transient dopamine dip (dip when N_tilda > 0). But in Brown's case the
% indirect is used just to withold movement, and not to inhibit ongoing
% movement (N_tilda is initially activated for too early release)

% influence of any candidate SSM choice cell contribute to indirect, 
% so as to increase the dynamic range 
CANDIDATE2INDIRECT = 0.125;

% Minimum SSM activity to be quenched syllable-shift trigger
SSM_THRESHOLD = 4;

% Contribution of fast-spiking interneurons to indirect pathway
FSIN_TO_INDIRECT = 0.3;

% The weight of the syllable-shifting trigger
MATCH_WEIGHT = 1; 

% Update striatum cells, indirect pathway
%
% IMPORTANT: use (cur.CORTEXc>1) so that other candidates inhibit only 
% when next syllable is about to be selected. Otherwise, motor programs  
% from both previous and next syllable will contribute to inhibition
dSTRi = -sim_BG_loop.STR.PARAM.A*cur.STRi + ... 
     ((1./beta_D2).*sim_BG_loop.STRi.PARAM.B - cur.STRi) ... 
    .*( MATCH_WEIGHT .* get_match(time) .* (cur.CORTEXc > SSM_THRESHOLD) .* white_matter_integrity ... 
    + CANDIDATE2INDIRECT .* (cur.CORTEXc > 1 & cur.CORTEXc <= SSM_THRESHOLD)) ... 
    - FSIN_TO_INDIRECT .* cur.STRi.*(STR_netInh); 

% Note:
% Original GODIVA version had decay in GPe
% Extended GODIVA model does not have decay
dGPe = (sim_BG_loop.GPe.PARAM.B - cur.GPe) - ...
    cur.GPe.*sum(cur.STRi); 

% Striatum provides strong contrast enhancement in the loop
STR2GPI = 60;

% Strength of inhibitory projection from GPe to GPi
GPE2GPI= 15; 

% Note:
% Original GODIVA version had decay in GPi
% Extended GODIVA model does not have decay
dGPi = (sim_BG_loop.GPi.PARAM.B - cur.GPi) - ... 
    cur.GPi.*((cur.STR).*STR2GPI + ... 
    cur.GPe.*GPE2GPI); 

% Strength of inhibitiory proejections from GPe to GPi
GPI2THAL = 10;

% Update the thalamus
dTHAL = (sim_BG_loop.THAL.PARAM.B - cur.THAL).*(cur.CORTEXp ... 
        + max(cur.THAL-1.5,0) ... 
        + sigf_cortexc(cur.CORTEXc)) ... % ensures that "winner" persists until trigger arrives
        - cur.THAL.*(GPI2THAL .* max(0,cur.GPi-0.1)); % supra-threshold GPi at 0.1 becuase difficult to push it below that value!

% STN stub
dSTN = zeros(size(cur.STN));

dx = [dSTR; dSTRi; dGPi; dSTN; dGPe; dTHAL];

function y = sigf_cortexc(x) % the same function used in update_SSM
y = x.^4;