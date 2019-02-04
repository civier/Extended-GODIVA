function x=get_inf_preSMA_gain(t)

%function x=get_inf_preSMA_gain(t)
%
% Provides momentary input from preSMA to SMA

    s = 0.4;

    x = (t <= 5) .* 0.05 + ...
        (t > 4 & t <= 5) .* (exp(-((t-5)./s).^2)) .* 0.45 + ...
        (t > 5) .* 0.5;

end
