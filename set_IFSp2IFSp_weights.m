function W = set_IFSp2IFSp_weights(IFSp)

% This function sets the strength of lateral inhibitory connections within
% the IFS planning layer.  Full, equal connectivity implements a "standard"
% recurrent competitive field.  The use of connectivity that varies
% according to some function of the representative cells can add similarity
% effects to the model.

% Here is the full recurrent competitive field weight matrix.
% SIZE(2) is the # of phonemes in the map (#phonemes x #sylpos x #copies)
W = ones(IFSp.PARAM.SIZE(1), IFSp.PARAM.SIZE(1));

W = W - diag(diag(W));  % zero out the diagonal (no self-inhibition)

% W is the internal layer weight matrix for a single column of cells 