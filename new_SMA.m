function [x,ncells] = new_SMA(ncells),

% function [x,ncells] = new_SMA(ncells),
% defines a new SMA component

if (exist('SMA.mat','file')),
    x = load('SMA.mat');
else
    x = load('default_SMA.mat');
end;

% use the # of cells that are stored in the .mat file
x.SMAp.indices = [ncells+1:ncells+prod(x.SMAp.PARAM.SIZE)];
ncells = ncells + prod(x.SMAp.PARAM.SIZE);

x.SMAc.indices = [ncells+1:ncells+prod(x.SMAc.PARAM.SIZE)];
ncells = ncells + prod(x.SMAc.PARAM.SIZE);