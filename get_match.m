function v = get_match(t)

% function v = get_match(t)
% Returns a shift-syllable signal that becomes very large when the motor
% program is nearing completion, indicating the time to shift to the next
% syllable.
% Used by the striatum component of the BG-vPMC loop. Pressumably impaired
% in stuttering.
%
% NOTE: Currently implemented based on hard-wired supressions, so 
% simulations can be ran without calling DIVA.

global_parameters;

% load parameter that indicates if suppression arrives from DIVA or
% hard-wired
global BG_suppression;

s = 0.2;

 % override fixed suppression
if ~isempty(BG_suppression)
    v = do_trigger .* 100.*BG_suppression;
else
    v = do_trigger .* 100 * (between(t,[trigger_t trigger_t+0.25]) | between(t,[trigger_t2 trigger_t2+0.25]) | between(t,[trigger_t3 trigger_t3+0.25]));
end
