function I = getInputVector(t)

% function I = getInputVector(t)
% This function provides the utterance plan as input at specific time

global_parameters;

I = zeros(53,7,3);

if between(t,[1,2]),
  [I,nil] = str2gradient(UTTERANCE);
end
