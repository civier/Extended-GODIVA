function v = get_DIVAsuppression(t)

%function v = get_DIVAsuppression(t)
% Returns a global suppression signal from the DIVA model.
% Currently a stub that uses the SSM_output_suppresion variable.

%global BG_suppression;
global SSM_output_suppression;

s = 0.2;

if ~isempty(SSM_output_suppression)
    v = 10 * SSM_output_suppression;
else
	v = 0;
end

