function [pos,d] = model_positions_new;

%function [pos,d] = model_positions_new;
% returns the MNI positions of differnt model components.
% can be used to plot activation on the brain.

fields = {...
    'motor_tongue',...
    'motor_lip',...
    'motor_jaw',...
    'motor_larynx',...
    'motor_respiration',...
    'ant_paravermis',...
    'cb_spl',...
    'cb_dcn',...
    'inf_prefrontal',...
    'frontal_operculum',...
    'ant_insula',...
    's_tongue',...
    's_lip',...
    's_jaw',...
    's_larynx',...
    's_palate',...
    'ba40',...
    'heschl',...
    'planum_temporale',...
    'SPT',...
    'pSTG',...
    'sma',...
    'caudate',...
    'putamen',...
    'pallidum',...
    'thalamus'}';
%     'sma'}';

for fn=1:length(fields),
    d.(fields{fn}) = fn;
end
    
% Motor components
pos(d.motor_tongue,:,1) = [-60.2 4.4 19.4]; % Motor tongue
pos(d.motor_lip,:,1)    = [-58.6 -1.9 34.6]; % Motor lip
pos(d.motor_jaw,:,1)    = [-60.2 2.2 26.5]; % Motor jaw
pos(d.motor_larynx,:,1) = [-58.1 6.0 6.4]; % Motor larynx
pos(d.motor_respiration,:,1) = [-17.4 -26.9 73.4]; % Motor respiration
pos(d.motor_tongue,:,2) = [62.1  -0.3 26.6]; % Motor tongue
pos(d.motor_lip,:,2)    = [58.1 2.8 35.3]; % Motor lip 54.7  -1.1 34.9]; % Motor lip
pos(d.motor_jaw,:,2)    = [58.0   2.1 30.8]; % Motor jaw
pos(d.motor_larynx,:,2) = [65.4 5.2 10.4]; %Motor larynx 65.4   8.4 12]; % Motor larynx
pos(d.motor_respiration,:,2) = [23.8 -28.5 70.1]; % Motor respiration

% SMA
pos(d.sma,:,1) = [0 0 68];
pos(d.sma,:,2) = [2 4 62];

% Subcortical network
pos(d.caudate,:,1) = [-12 -2 14];
pos(d.putamen,:,1) = [-26 -2 4];
pos(d.pallidum,:,1) = [-24 -2 -4];
pos(d.thalamus,:,1) = [-10 -14 8];

pos(d.caudate,:,2) = [14 -2 14];
pos(d.putamen,:,2) = [30 -14 4];
pos(d.pallidum,:,2) = [24 2 -2];
pos(d.thalamus,:,2) = [10 -14 8];

% Cerebellum
pos(d.ant_paravermis,:,1) = [-18 -59 -22]; % Ant. paravermis
pos(d.cb_spl,:,1)         = [-36 -59 -27]; % SPL
pos(d.cb_dcn,:,1)         = [-10.3 -52.9 -28.5]; % DCN
pos(d.ant_paravermis,:,2) = [16 -59 -23]; % Ant. paravermis
pos(d.cb_spl,:,2)         = [40 -60 -28]; % SPL
pos(d.cb_dcn,:,2)         = [14.4 -52.9 -29.3]; % DCN

% Speech sound map
pos(d.inf_prefrontal,:,1)    = [-56.2 17.8 1.4]; %-57.0 11.2 6.1]; % Inf prefrontal
pos(d.frontal_operculum,:,1) = [-39.9 20.2 7.7]; % Frontal operculum
pos(d.ant_insula,:,1)        = [-36.6 20.2 -0.5]; % Anterior Insula
pos(d.inf_prefrontal,:,2)    = [58.0 11.2 2.0]; % Inf prefrontal
pos(d.frontal_operculum,:,2) = [40.7 23.5 7.7]; % Frontal operculum
pos(d.ant_insula,:,2)        = [39.9 22.7 0.03]; % Anterior Insula

% Sensory components
pos(d.s_tongue,:,1) = [-60.2 0.6 20.8]; % Tongue
pos(d.s_lip,:,1)    = [-58.8 -5.9 34.6]; % Lip
pos(d.s_jaw,:,1)    = [-60.2 -1.1 25.7]; % Jaw
pos(d.s_larynx,:,1) = [-61.8 1 7.5]; % Larynx
pos(d.s_palate,:,1) = [-58 -0.7 14.3]; % Palate
pos(d.s_tongue,:,2) = [62.1	-3.6	27.5]; % Tongue
pos(d.s_lip,:,2)    = [60.5 -2.8 36.0]; %Lip 54.7	-6.1	34.0]; % Lip
pos(d.s_jaw,:,2)    = [58.0	-2.0	31.6]; % Jaw
pos(d.s_larynx,:,2) = [65.4 1.2 12.0]; % Larynx 65.4	1.0	15.1]; % Larynx
pos(d.s_palate,:,2) = [65.4 -0.4 21.6]; % Palate

% Somatosensory error cells
pos(d.ba40,:,1) = [-62.1 -28.4 32.6]; %BA40 -62.9  -26.0  33.6]; % BA40
pos(d.ba40,:,2) = [66.1  -24.4  35.2]; % BA40

mean([-62.1	-23.8	29.1;...
-58.8	-21.7	39.8;...
-60.5	-23.8	34.0;...
-62.1	-25.4	15.1;...
-62.1	-25.4	25.0]); % left
mean([65.4	-20.5	32.4;...
62.1	-23.8	41.4;...
65.4	-21.7	35.7;...
66.2	-19.7	15.1;...
66.2	-19.7	25.0]); % right

% Auditory state cells
pos(d.heschl,:,1)           = [-37.4 -22.5 11.8]; % Heschl's gyrus
pos(d.planum_temporale,:,1) = [-57.2 -18.4  6.9]; % Planum temporale
pos(d.heschl,:,2)           = [39.1	-20.9	11.8]; % Heschl's gyrus
pos(d.planum_temporale,:,2) = [59.6	-15.1	6.9]; % Planum temporale

% Auditory error cells
pos(d.SPT,:,1)  = [-39.1 -33.2 14.3]; % Area SPT
pos(d.pSTG,:,1) = [-64.6 -33.2 13.5]; % pSTG
pos(d.SPT,:,2)  = [44.0	-30.7	15.1]; % Area SPT
pos(d.pSTG,:,2) = [69.5	-30.7	5.2]; % pSTG
