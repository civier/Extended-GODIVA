%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  habituation
%  =============
%
%  Calculate the expected habituation in a set of neurons.
%  Can be used for more realistic simulation of BOLD response.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: neurons = habituation(neurons,B)
%
%           neurons - the current activation values of the neurons
%
%           B - the habituation threshold
%        
%  Output: neurons - the updated activation of the neurons after
%  habituation
%
%  Authors: Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function neurons = habituation(neurons,B)

    %each row is all the cells at a point in time
    for i=1:size(neurons,2)
        cell = neurons(:,i);
        
        % check if above threshlold. Only the syllable currently active
        % should be above this threshold
        winner_idx = find(cell>B-1);
        if any(winner_idx)
            HABITUATION = [ones(1,200),1:-0.005:0,zeros(1,10000)];
            cell(winner_idx) = cell(winner_idx) .* HABITUATION(1:length(winner_idx))';
            neurons(:,i) = cell;        
        end
    end
    
end