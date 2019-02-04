%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  plot_all
%  ========
%
%  Plot the results of the simulation.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: plot_all(sim,X)
%
%         sim - the output of the simulation
%         X   - parameters of simulation
%
%  Author:  Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_all(sim,X);

    global simulation;
    global GODIVA2ms;

    IS_TITLE = false;

    if ~exist('simulation')
        'please set simulation variable to one of the following:'
        'normal, DA, DA_medicated, WMF, WMF_medicated'
        return;
    end

    global_parameters;

    figure;
    subplot(511);
    plot(sim.time.*GODIVA2ms,sim.output(:,X.SSM.SSMp.indices));
    if IS_TITLE
         title([simulation ': SSM Plan Layer'],'FontSize',12,'Color','k');
    end
    axis([0 max(X.TIME).*GODIVA2ms 0 3]);

    subplot(512);
    plot(sim.time.*GODIVA2ms,sim.output(:,X.SSM.SSMo.indices));
    if IS_TITLE
        title([simulation ': SSM Choice Layer'],'FontSize',12,'Color','k');
    end
    hold on; plot([0 max(X.TIME).*GODIVA2ms],[4 4],'--k');
    axis([0 max(X.TIME).*GODIVA2ms 0 5.5]);

    subplot(513);
    plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.THAL.indices),'-')
    if IS_TITLE
        title([simulation ': BG-vPMC loop - Thal'],'FontSize',12,'Color','k');
    end
    axis([0 max(X.TIME).*GODIVA2ms 8.8 10.2]);    
    hold on; plot([0 max(X.TIME).*GODIVA2ms],[9 9],'--k');
    hold on; plot([0 max(X.TIME).*GODIVA2ms],[10 10],':k');

    subplot(514);
    plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.STR.indices),'-')
    if IS_TITLE
        title([simulation ': BG-vPMC loop - Put D1'],'FontSize',12,'Color','k');
    end
    axis([0 max(X.TIME).*GODIVA2ms 0 1]);

    subplot(515);
    plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.STRi.indices),'-')
    if IS_TITLE
        title([simulation ': BG-vPMC loop - Put D2'],'FontSize',12,'Color','k');
    end
    hold on; plot(sim.time.*GODIVA2ms,sum(sim.output(:,X.BG_loop_motor.STRi.indices)')',':')
    axis([0 max(X.TIME).*GODIVA2ms 0 50]);

end