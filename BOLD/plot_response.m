%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  plot_response
%  =============
%
%  Plots the predicted BOLD contrast between a given simulation and 
%  simulation of a healthy adult.
%  Convolve a hrf function separately with the neural activations of the 
%  clinical condition and the normal condition, and calculate the
%  difference.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: plot_response(sim,X,duration)
%
%           sim - the simulation results
%
%           X - the parameters of the simulation
%        
%           duration - duration of simulation in miliseconds
%                      (recommendation: for simulation up to syllale S,
%                                       simulate up to the time that the
%                                       activity of the next syllable in
%                                       line is greater than the activity
%                                       of syllable S)
%           
%           (The output of a normal simulation,i.e. sim,X,duration, should 
%            be available in ../normal.mat.
%            The normal.mat provided by default is for the utterance 
%            'GODIVA', 11s simulation)
%
%  Output: plots of the BOLD contrast between the condition and normal
%          utterance
%
%  Authors: Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_response(condition_sim,condition_X,duration);
  global simulation;
   
  addpath ..;
  
  global_parameters;
  
  % load the HRF response function
  global hrf;
  load('hrf');

  % Get rid of refractory period of hrf
  hrfMax=5;
  hrf = hrf(1:hrfMax+1);
  hrf = interp1(1:length(hrf),hrf,(1:0.001:hrfMax+.2)','pchip');

  %% The thresholds are the minimum activity needed for the region to send
  %% signal to other regions of the brain
  SSMp_THRESH = 0; 
  SSM_THRESH = 0; 
  THAL_THRESH = 0; 
  GPi_THRESH = 0; 
  GPe_THRESH = 0; 
  STR_THRESH = 0; 
  STRi_THRESH = 0;
  
  fld = {'SSM','SSMo',SSM_THRESH, 'SSM','SSMp',SSMp_THRESH;
         'BG_loop_motor','THAL',THAL_THRESH,null(1),null(1),null(1);
         'BG_loop_motor','GPi',GPi_THRESH, 'BG_loop_motor','GPe',GPe_THRESH;
         'BG_loop_motor','STR',STR_THRESH, 'BG_loop_motor','STRi',STRi_THRESH};
  
  % normal condition
  load ('..\normal.mat')
  [activity,B] = time_sum_bold(sim,X,fld,duration);

  % clinical condition
  sim = condition_sim;
  X = condition_X;
  [activity_st,B_st] = time_sum_bold(sim,X,fld,duration);

  % plot BOLD response and activity
  figure;
  for i=1:size(fld,1)
    plot_diff_BOLD_orig(size(fld,1),i,fld{i,2},B{i},B_st{i},activity{i},activity_st{i});
  end

  % plot relative BOLD response
  figure;
  for i=1:size(fld,1)
     plot_diff_BOLD_relative(size(fld,1),i,fld{i,2},B{i},B_st{i},activity{i},activity_st{i},1);
  end

end

% function to calculate the total activation of the model over time (in
% each component) and perform convolution with hrf function
function [activity,B] = time_sum_bold(sim,X,fld,duration);        
      global GODIVA2ms;
      global hrf;
      
      % scale simulation to be in real time units
      GODIVA2DIVA_stretch_indices = round(linspace(1,size(sim.output,1),max(X.TIME)*GODIVA2ms));  % turn the simulations into real time in ms (the time given in the plots)
      GODIVA2DIVA_stretch_indices = GODIVA2DIVA_stretch_indices(1:duration); % duration in the units of the plots

      % sum the activity in the relevant fields of each component
      for i=1:size(fld,1)
          for s=0:3:3
             if ~isempty(fld{i,1+s})
                 temp = sum(max(sim.output(:,X.(fld{i,1+s}).(fld{i,2+s}).indices) - fld{i,3+s},0),2)';
                 if s==0
                     activity{i} = temp;
                 else
                     activity{i} = activity{i} + temp;
                 end
             end
          end
          activity{i} = activity{i}(GODIVA2DIVA_stretch_indices);
          
          % convolve with hrf
          B{i} = bold_resp(activity{i},hrf,1,0);
      end
    end
    