function [W] = set_IFS2SSM_weights(IFS,SSM,varargin)

% FUNCTION [W] = set_IFS2SSM_weights(IFS,SSM,[NOISE])
%
% Returns a sparse matrix indicating the strengths of connections from the
% IFS phoneme-based representation to the SSM cells.
% INPUTS: 
% IFS - a character array of the (DISC phonetic transcription)
%       phonemic elements represented in the IFS layer
% SSM - a cell array of character arrays containing the phonetic
% transcription for each syllable (and phoneme?) in the SSM layer
% NOISE - the standard deviation of noise values added to the
% algorithmically determined weights

numPos = 7;     % position coded representation (1-7, 4 is vowel)
if nargin < 2, help('set_IFS2SSM_weights'); return;
elseif nargin < 3, N = length(SSM); NOISE=0;
elseif nargin < 4, NOISE = 0; N = varargin{1};
else NOISE = varargin{2};
end;

W = sparse(length(IFS)*numPos,N);

for i = 1:N, % loop through each stored SSM rep
    newW = zeros(length(IFS),numPos);
    
    speech_sound = char(SSM(i));
    posIdx = strfind('CCCVCCC',get_CV_structure(speech_sound));
    if (length(posIdx)>1), posIdx = posIdx(1); end; % JUST THE FIRST
    
    for p = 1:length(speech_sound), % for each phoneme in the speech sound
        % Find the index into IFS for this phoneme

        
        phoneIdx = strfind(IFS,speech_sound(p));

        newW(phoneIdx,posIdx) = 1;
        posIdx = posIdx + 1;
        
        % if this is a single consonant, give it entries in positions 1-3
        % and 5-7
        if (strmatch(get_CV_structure(speech_sound),'C','exact')),
            newW(phoneIdx,[1:3 5:7]) = 1;   % THIS IS THE NORMALIZATION ISSUE!
        end;
    end;
    
    if (isempty(strmatch(get_CV_structure(speech_sound),'C','exact'))),
        if (~isempty(strmatch(get_CV_structure(speech_sound),'V','exact')))
            W(:,i) = newW(:) * 0.65; % this is JUST a vowel program
        else
            W(:,i) = newW(:) ./ norm(newW(:),1); % this is a syllable program > 1 phoneme
        end;
    else
     newW = newW .* repmat([0.8 0.75 0.7 0 0.6 0.55 0.5],53,1);
     W(:,i) = newW(:); % this is just a consonant program
    end;
    
end;

W(isnan(W(:))) = 0; 
