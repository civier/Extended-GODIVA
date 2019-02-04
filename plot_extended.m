% plot function called at the end of the simulation

simulation = 'normal';
global_parameters;

figure;
fs = 8;

subplot(811);
plot(sim.time.*GODIVA2ms,sim.output(:,X.SSM.SSMp.indices));
title('SSM Plan Layer','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 0 3]);

subplot(812);
plot(sim.time.*GODIVA2ms,sim.output(:,X.SSM.SSMo.indices));
title('SSM Choice Layer','FontSize',fs,'Color','k');
hold on; plot([0 max(X.TIME).*GODIVA2ms],[4 4],'--k');
axis([0 max(X.TIME).*GODIVA2ms 0 5]);

subplot(813);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.THAL.indices),'-')
title('BG-vPMC loop - Thal - high pass','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 8.8 10.2]);    
hold on; plot([0 max(X.TIME).*GODIVA2ms],[9 9],'--k');
hold on; plot([0 max(X.TIME).*GODIVA2ms],[10 10],':k');

subplot(814);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.THAL.indices),'-')
title('BG-vPMC loop - Thal - full range','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 0 11]);    
hold on; plot([0 max(X.TIME).*GODIVA2ms],[9 9],'--k');
hold on; plot([0 max(X.TIME).*GODIVA2ms],[10 10],':k');

subplot(815);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.GPi.indices),'-')
title('BG-vPMC loop - GPi','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 0 3]);    

subplot(816);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.STR.indices),'-')
title('BG-vPMC loop - Put D1','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 0 1]);

subplot(817);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.GPe.indices),'-')
title('BG-vPMC loop - GPe','FontSize',fs,'Color','k');
axis([0 max(X.TIME).*GODIVA2ms 0 1]);    

subplot(818);
plot(sim.time.*GODIVA2ms,sim.output(:,X.BG_loop_motor.STRi.indices),'-')
title('BG-vPMC loop - Put D2','FontSize',fs,'Color','k');
hold on; plot(sim.time.*GODIVA2ms,sum(sim.output(:,X.BG_loop_motor.STRi.indices)')',':')
axis([0 max(X.TIME).*GODIVA2ms 0 50]);
