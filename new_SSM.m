function [x,ncells] = new_SSM(varargin),

% function [x,ncells] = new_SSM(varargin),
% defines a new SSM component

if nargin < 1, help('new_SSM'); return; end;

ncells = varargin{1};

if (exist('SSM.mat','file')),
    x = load('SSM.mat');
else
    x = load('default_SSM.mat');
end;

if nargin < 2, nSSMcells = x.SSMp.PARAM.N; % use the default
else nSSMcells = varargin{2}; % use the passed argument
    x.SSMp.PARAM.N = nSSMcells; % set the # of plan cells
    x.SSMo.PARAM.N = nSSMcells; % set the # of output cells
end;

% use the # of cells that are stored in the default .mat file
x.SSMp.indices = [ncells+1:ncells+nSSMcells];
x.SSMo.indices = [ncells+nSSMcells+1:ncells+2*nSSMcells];

ncells = ncells + 2*nSSMcells;  % update the total # of modeled cells
