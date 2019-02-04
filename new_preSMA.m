function [x,ncells] = new_preSMA(ncells),

% function [x,ncells] = new_preSMA(ncells),
% defines a new preSMA

if (exist('preSMA.mat','file')),
    x = load('preSMA.mat');
else
    x = load('default_preSMA.mat');
end;

% use the # of cells that are stored in the .mat file
x.preSMAp.indices = [ncells+1:ncells+prod(x.preSMAp.PARAM.SIZE)];
ncells = ncells + prod(x.preSMAp.PARAM.SIZE);

x.preSMAc.indices = [ncells+1:ncells+prod(x.preSMAc.PARAM.SIZE)];
ncells = ncells + prod(x.preSMAc.PARAM.SIZE);