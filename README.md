%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Extended GODIVA model
%  =====================
%
%  An extended version of the neuro-computational model GODIVA. Includes
%  a basal ganglia (BG) - ventral premotor cortex (vPMC) loop that serves 
%  to select and initiates the correct syllables and in a timely manner.
%
%  The code was used for the simulations of developmental stuttering 
%  resulting from elevated dopamine levels and impaired corticostriatal 
%  projects (Civier et al., 2013).
%
%  The code implements the formulas given in the supplementary material of
%  Civier et al. (2013). Each component has a function that implements it, 
%  prefixed by "update_". The model is based on the original GODIVA model 
%  (Bohland et al., 2010).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Usage: sim = godiva(length,condition)
%
%         <length> - the length of the simulation in GODIVA time units
%         <condition> - what condition to simulate:
%                       'normal' - healthy individual
%                       'DA'     - elevated dopamine levels
%                       'WMF'    - what matter fibers impairment
%
%  Output: plot of the results (generated with 
%          sim - the simulation results
%                   sim.output (neural activation over time)
%                   sim.model (the paramaters of the model)
%                   sim.time (time steps used)
%
%  Next step: run plot_all to show output of simulation
%             run plot_colors to show important info on simulation
%             run BOLD/plot_response to plot hemodynamic response
%
%  Config files: 1) Global_parameters.m includes the parameters used
%                   for each condition, as well as the utterance to be 
%                   produced.
%
%                2) ./defaults subdirectory includes a .mat for every 
%                   component in the model. The file specifies the A and B 
%                   parameters for all shunting equations used.
%                   The defaults can be overriden by including a .mat file
%                   with the same name in the ./custom subdirectory 
%                   (but without the 'default_' prefix).
%
%  Author: Oren Civier
%  Version: 2.01
%  Date: 26/12/2011
%
%  REFERENCES:
%  
%  Bohland, J. W., Bullock, D., and Guenther, F. H. (2010) Neural 
%  representations and mechanisms for the performance of simple speech
%  sequences. Journal of Cognitive Neuroscience , 22(7), pp. 1504–1529.
%
%  Civier, O., Bullock, D., Max, L., and Guenther, F. H. (2013) 
%  Computational modeling of stuttering caused by impairments in a basal 
%  ganglia thalamo-cortical circuit involved in syllable selection and 
%  initiation. Brain and Language, 126(3), 263–278
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
