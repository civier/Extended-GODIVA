function F = getFrameInput(t)

% function F = getFrameInput(t)
% This functions get the hard-wired definition of frame for
% simple CV syllables.

F = zeros(9,5);  % size of preSMA rep

if between(t,[1,1.5]),
    F(3,1) = 1;
    F(3,2) = 0.67;
    F(3,3) = 0.33;
end
