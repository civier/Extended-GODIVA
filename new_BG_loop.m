function [x,ncells] = new_BG_loop(ncells,type),

% function [x,ncells] = new_BG_loop(ncells,type),
% define a new BG loop

x = load(['default_BG_loop_',type,'.mat']);

% Now assign the proper indices into the dynamical system variables
x.STR.indices = [ncells+1:ncells+x.STR.PARAM.N];
ncells = ncells + x.STR.PARAM.N;
x.STRi.indices = [ncells+1:ncells+x.STRi.PARAM.N];
ncells = ncells + x.STRi.PARAM.N;
x.GPi.indices = [ncells+1:ncells+x.GPi.PARAM.N];
ncells = ncells + x.GPi.PARAM.N;
x.STN.indices = [ncells+1:ncells+x.STN.PARAM.N];
ncells = ncells + x.STN.PARAM.N;
x.GPe.indices = [ncells+1:ncells+x.GPe.PARAM.N];
ncells = ncells + x.GPe.PARAM.N;
x.THAL.indices = [ncells+1:ncells+x.THAL.PARAM.N];
ncells = ncells + x.THAL.PARAM.N;

