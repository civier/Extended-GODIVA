function [u_ifs, u_preSMA] = str2gradient(ps)

% function [u] = function str2gradient(ps,phones,frames)
% -----------------------------------------------
% This function takes an intended utterance "chunk" as a phoneme string,
% with syllable boundaries demarcated by periods (.) and computes inputs to
% the IFS phonological content represenation, and to the pre-SMA 'frame'
% representation. The input must use the DISC phonetic alphabet as used in
% the CELEX database.  See DISC.txt file included in the project EXAMPLE:
% str2gradient('gUd.k{ts') -- for "good cats"
% ps - a string
% phones - a cell array of phonemes in the IFS vector
% frames - a cell array of known frame types in preSMA vector 

% First parse out the input into syllable sized tokens
% Initialize

phones = cellstr(['#$0123456789@CDEFHIJNPQRSTUVZ_bcdfghijklmnpqrstuvwxz{']');
frames = {'C','V','CV','CVC','VC','CVCC','CCV','CCVC','VCC'};

rem = ps;
i=1;
numphonemes = 0;

% Loop through syllable tokens
while true,
 [syl{i} rem] = strtok(rem,'.');
 numphonemes = numphonemes + length(syl{i}); % increment phoneme count
 if isempty(rem), break; end; % no more to read
 i = i+1;
end;

IFSrep = zeros(length(phones),7,3);  % new IFS rep
preSMArep = zeros(length(frames),1);

% Build gradient representations across IFS cells and preSMA cells
% Be careful about repeating elements (currently no implementation!)
current = numphonemes;
for i=1:length(syl),
    cv{i} = get_CV_structure(syl{i});
    frm = strcmp(cv{i},frames);
    if any(frm > 0) % found this frame type,
        preSMArep(find(frm==1)) = length(syl)-(i-1);
    else
        % Do this phoneme by phoneme
        fprintf('This syllable type is not implemented');
        return;
    end;
    startIdx = strfind('CCCVCCC',cv{i});
    for j=1:length(syl{i}),
        IFSrep(strmatch(syl{i}(j),phones),startIdx-1+j,1) = current;
        current = current-1;
    end;
end;

u_ifs = IFSrep ./ max(IFSrep(:));
u_preSMA = preSMArep;