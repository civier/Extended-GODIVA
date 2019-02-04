%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  godiva_update
%  =============
%
%  Updating the state of the model. Being called by the ODE solver.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: godiva_update(time,curX,sim)
%
%         time - length of simulation in seconds
%         curX - current state of the model
%                       'normal' - healthy individual
%
%  Authors:  Oren Civier
%            Jay Bohland
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = godiva_update(time,curX,sim)

time

% 0 - do not update IFS and SSM
% 1 - also update IFS and SSM
UPDATE_ALL = 1;

% Only pass each function the activations it needs to compute its update
% Pass these in a structure that each individual layer update function will
% need to "expect"

IFSp = curX(sim.IFS.IFSp.indices);
IFSc = curX(sim.IFS.IFSc.indices);
preSMAp = curX(sim.preSMA.preSMAp.indices);
preSMAc = curX(sim.preSMA.preSMAc.indices);

CAUD = curX(sim.BG_loop_plan.STR.indices);
CAUDi = curX(sim.BG_loop_plan.STRi.indices);
GPi = curX(sim.BG_loop_plan.GPi.indices);
STN_plan = curX(sim.BG_loop_plan.STN.indices);
GPe_plan = curX(sim.BG_loop_plan.GPe.indices);
VA = curX(sim.BG_loop_plan.THAL.indices);

PUT = curX(sim.BG_loop_motor.STR.indices);
PUTi = curX(sim.BG_loop_motor.STRi.indices);
SNpr = curX(sim.BG_loop_motor.GPi.indices);
STN_motor = curX(sim.BG_loop_motor.STN.indices);
GPe_motor = curX(sim.BG_loop_motor.GPe.indices);
VL = curX(sim.BG_loop_motor.THAL.indices);

SSMp = curX(sim.SSM.SSMp.indices);
SSMo = curX(sim.SSM.SSMo.indices);
SMAp = curX(sim.SMA.SMAp.indices);
SMAc = curX(sim.SMA.SMAc.indices);

ifs_in = struct('IFSp',IFSp,'IFSc',IFSc,'THAL',VA,'SSMo',SSMo);
bg_loop_plan_in = struct('STR',CAUD,'STRi',CAUDi,'GPi',GPi,'STN',STN_plan,'GPe',GPe_plan,'THAL',VA,'CORTEXc',preSMAc);
bg_loop_motor_in = struct('STR',PUT,'STRi',PUTi,'GPi',SNpr,'STN',STN_motor,'GPe',GPe_motor,'THAL',VL,'CORTEXp',SSMp,'CORTEXc',SSMo);
SSM_in = struct('IFSc',IFSc,'SSMp',SSMp,'SSMo',SSMo,'SMAc',SMAc,'THAL',VL); % SMAc is needed for global suppression
preSMA_in = struct('preSMAp',preSMAp,'preSMAc',preSMAc);
SMA_in = struct('SMAp',SMAp,'SMAc',SMAc,'SSMo',SSMo,'THAL',VL);

% The original GODIVA version implemented the BG planning loop.
% Extended GODIVA model uses the stub below.
dBG_loop_plan = zeros(length(CAUD)+length(CAUDi)+length(GPi)+length(STN_plan)+length(GPe_plan)+length(VA),1); 

% Update higher level IFS and SSM cells
if UPDATE_ALL
    dIFS = update_IFS(ifs_in,sim,time);
    dSSM = update_SSM(SSM_in,sim,time);
else
    dIFS = zeros(length(IFSp)+length(IFSc),1);
    dSSM = zeros(length(SSMp)+length(SSMo),1);
end

% The original GODIVA version implemented the preSMA.
% The extended GODIVA model uses the stub below.
dPreSMA = zeros(length(preSMAp)+length(preSMAc),1);

% SMA is used for global supression
dSMA = update_SMA(SMA_in,sim,time); % Oren 

% Motor loop
dBG_loop_motor = update_BG_loop_motor(bg_loop_motor_in,sim.BG_loop_motor,time); % Oren
    
% add each of the region updates to this vector for the full update vector
% IMPORTANT: watch out that order is like in godiva.m !!!
dx = [dIFS; dPreSMA; dBG_loop_plan; dSSM; dSMA; dBG_loop_motor]; 