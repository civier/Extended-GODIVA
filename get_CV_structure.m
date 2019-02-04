function [cv] = get_CV_structure(ps)

% function [cv] = get_CV_structure(ps)
% This function returns the CV structure for a single syllable, and
% optionally checks it against a list of known CV structures.  If this CV
% type is not known, then the structure is reduced to single consonants and
% vowels?

% An array of vowels to be used for frame cell selection
vowels = 'i#$u312456789IE{QVU@0cq';

for i=1:length(ps),
    if strfind(vowels,ps(i)), 
        cv(i) = 'V';
    else
        cv(i) = 'C';
    end;
end;
