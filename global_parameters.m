%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  global paramaters
%  =================
%
%  Global parameters used by all functions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: global_parameters
%
%  Note:  The timing of triggers is hard-wired for simulations of 
%         'GO-DI-VA'. Change depending on utterance, or integrate with
%         the GODIVA model for on-the-fly trigger timing.
%
%  Author:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The utterance the model needs to produce
UTTERANCE = 'g5.di.v@';

% The relationship between real time and simulation time
global GODIVA2ms;
GODIVA2ms = 150;

% The condition simulated
global simulation;

% Normal DA levels
beta_D1 = 1; 
beta_D2 = 1; 
    
% Normal whime matter integrity
white_matter_integrity = 1;

switch simulation

    % Normal simulation
    case 'normal',
        trigger_t  = 6.5-0.5; 
        trigger_t2 = 9.5-1; 
        trigger_t3 = 12.5; 
        do_trigger = 1;

    % Elevated DA simulation
    case 'DA', 
        beta_D1 = 1.6; 
        beta_D2 = 1.6; 
        DELAY = (699-585)./GODIVA2ms; % start time of 1st syllable
        trigger_t=6.5+DELAY-0.5; 
        trigger_t2=9.5+DELAY-1; 
        trigger_t3=12.5+DELAY; 
        do_trigger = 0;

    % Impaired white matter fibers simulation
    case 'WMF',         
        white_matter_integrity = 0.01;
        
        DELAY = (1194-1042)./GODIVA2ms; % start time of 1st syllable
        
        trigger_t=6.5-0.5; 
        trigger_t2=9.5+DELAY-1; 
        trigger_t3=12.5+2.*DELAY; 
        do_trigger = 1;

    otherwise,
        dbstop;
end
