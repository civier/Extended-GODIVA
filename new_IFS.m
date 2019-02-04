function [x,ncells] = new_IFS(ncells),

% function [x,ncells] = new_IFS(ncells),
% defines a new IFS component

% Takes a number of cells already assigned to the model, uses this to
% create appropriate values in 'indices' field, updates # of cells, then
% passes the structure and this updated ncells value back

% Allow the user to create a new IFS.mat file with new parameters or
% numbers of cells, etc.  Load it if it exists in the path.
if (exist('IFS.mat','file')),
    x = load('IFS.mat');
else
    x = load('default_IFS.mat');
end;

x.IFSp.PARAM.SIZE(2) = 7; %7 for 7 poositions inside the syllable
x.IFSc.PARAM.SIZE(2) = 7; %7 for 7 poositions inside the syllable

% Use the # of cells parameter that is stored in the mat file
x.IFSp.indices = [ncells+1:ncells+prod(x.IFSp.PARAM.SIZE)];
ncells = ncells + prod(x.IFSp.PARAM.SIZE);

x.IFSc.indices = [ncells+1:ncells+prod(x.IFSc.PARAM.SIZE)];
ncells = ncells + prod(x.IFSc.PARAM.SIZE);

x.IFSp.PARAM.A = 0.1;
x.IFSp.PARAM.B = 5;



