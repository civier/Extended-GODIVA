%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  plot_colors
%  ===========
%
%  Plot information on the simulation 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: plot_colors(sim,X);
%
%         sim - the output of the simulation
%         X   - parameters of simulation
%
%  Author:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_colors(sim,X);

    global_parameters = 'normal'
    t=300;

    % plot SSMs
    plot(1:2,[sim.output(t,X.SSM.SSMp.indices); sim.output(t,X.SSM.SSMp.indices)])
    % active SSMs
    aSSMs = find(sim.output(t,X.SSM.SSMp.indices) > 0)
    % their symbols
    X.SSM.SSMp.symbol(aSSMs)
    % highest
    max_SSM = find(sim.output(t,X.SSM.SSMp.indices) == max(sim.output(t,X.SSM.SSMp.indices)))
    % its symbol
    X.SSM.SSMp.symbol(max_SSM)

end