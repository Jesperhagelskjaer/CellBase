%The functions created by Jesper Hagelskjær

% initcb                         ()
% addnewcells_J                  ()  


%%
% add_analysis()
% average_firing_rate          (done)
% AUC_reward_choice            (done)!
% Baiting                      (done)
% behaviour_neurons_kernels    (done)
% behaviour_kernels            (done)
% cellid2rezFile               (done)
% choice_and_reward            (done)! 

% history_reward_choice        (done)!   
% IC_refractary_period         (done)
% NSSD_simularity_score        (done) 
% tagging_pv                   (done) 
% timing_CB_recording        
% checking_kernels        

%% Real time function
% template_real_time            () %building the template from the light pulse



%to run the different functions load the cellbase into the workspace and then run the different script given below
%some of the script requires access to other variable given in other script
%if they are not in these variable is not in the TheMatrix you will be
%asked to run the given script 
%% initcb

% initcb('name','overwrite',1)

% name -> the name of your new cellbase :)
% 'overwrite' -> [1/0] 1) will create TrialEvents.mat file and overwrite it if already exists   

%% 
% add_analysis(function handle,add_to_matrix,'property_names',{names_of_output variable},'arglist',{names_of__input_variable)

%e.g.
    
%arglist -> name-pairs 
%      
%     'cells' - [1 5 7 100] run the analysis on the given idx of the cells e.g. add_analysis(function hanel,add_to_matrix,'property_names',{names_of_output variable},'arglist',{'cells',)

%% Average Firing rate in the centerport  

   % add_analysis(@average_firing_rate,1,'property_names',{'CentralPortEpoch','Total_FR'});

   
% Calculates the average firing rate of the given neuron in the epoch  
   
%property_names ->
%            CentralPortEpoch           average firing rate in the center port 
%            Total_FR                   Total average firing of the neuron in the session 

% 'arglist' 
    % 'path' (default) cellbase path -> the path to the recording 

    
    
%% 

    %add_analysis(@AUC_reward_choice,0,'property_names',{'AUC_past_choice_r', 'AUC_past_reward_right', 'AUC_past_choice_nr', 'AUC_past_reward_left','AUC_next_choice', 'AUC_next_choice_control'});


%% 


%add_analysis(@Baiting,'property_names',1,{'BaitingFactor'})    

%% Calculate the coefficients for the behaviour behavior_kernels
% Using the bional lassoGLM to predict the current choose from the input  


    % add_analysis(@behavior_kernels,0,'property_names',{'B_trial_behaviour'},'arglist',{'data',{'choice','reward','no_reward'}})
    
% 'arglist'
    % 'data' -> default (R NR) [-1 1]
    %       'C'  -> The choice kernel, implements both left and right as [choice == -1 choice == 1]        (left == -1,right == 1)
    %       'R'  -> The reward kernel, implements both left and right as [reward == -1 reward == 1]        (left == -1,right == 1)
    %       'NR' -> The no_reward,     implements both left and right as [no_reward == -1 no_reward == 1]  (left == -1,right == 1)
    
    % loops  -> (default 25) the number of times the lasso regression is calculated for each session where the median of the calculated kernels is returned as B_trial_behaviour
    % trials -> Number of trials back in time taking into the regression analysis. Must be same or have a smaller size than the  
%output     
    % B_trial_behaviour -> the coefficients for the lasso regression on the data structure given by the input 'data' given in the order as the input     

%error that could happen
%1) 
%    you are trying to do lasso regression on more than the coefficients there a avariable in the NR, R, C kernels    
    
%% add_analysis(@behaviour_neurons_kernels,1,'property_names',{'B_trial_neuron','p_trial_neuron'})    

%'property_names'

    % B_trial_neuron -> the calculated kernels 
    % p_trial_neuron -> the calcualted p-value set to 5 % confidence interval
    % chow           -> test if the two half of the the hehavior is stable
    % AUC/AUC_bootstr->
        %   'bootstrap' -> (default 0 - no bootstraping) otherwise give a positive number on the number of bootstrapping  
        %   'transform' -> (default - 'none')  'swap' 'scale'}))   % rescaling the AUC value 
        %   'display'   -> (default - false)     (0 1)   

% 'arglist'
    % 'data' -> default (R NR) [-1 1]
    %       'C'  -> The choice kernel, implements both left and right as [choice == -1 choice == 1]        (left == -1,right == 1)
    %       'R'  -> The reward kernel, implements both left and right as [reward == -1 reward == 1]        (left == -1,right == 1)
    %       'NR' -> The no_reward,     implements both left and right as [no_reward == -1 no_reward == 1]  (left == -1,right == 1)
    
    % loops  -> (default 25) the number of times the lasso regression is calculated for each session where the median of the calculated kernels is returned as B_trial_behaviour
    % trials -> Number of trials back in time taking into the regression analysis. Must be same or have a smaller size than the  

% Chow test 
% The https://en.wikipedia.org/wiki/Chow_test
    
    
%% CellID to rez file - cellid2rezFile    

%add_analysis(@cellid2rezFile,1,'property_names',{'ID'})

%property_names ->
%   ID cellid to rez

% 'arglist' 
    % 'path' (default - cellbase path -> the path to the recording      
    % 'name' (default - 'rezFinalK')
    
%% The current choice and reward - Choice_and_reward

    % add_analysis(@choice_and_reward,1,'property_names',{'CH','RH','Indices_to_erase'})

% Calcualte the choice and reward history of the animal. Will only calcualte it for the first neurons and set det rest to an emptu entry in the Matrix    
% will you to much memory otherwise
  
% output 
    % CH               -> The choice error trial (nan)
    % RH               -> The Reward error trial (nan)  
    % Indices_to_erase -> Behavior trials which failed   
    
% 'arglist' 
    % 'path' (default) cellbase path -> the path to the recording   
    
%% The choice and reward history - Choice_and_reward history


% add_analysis(@history_reward_choice,1,'property_names',{'C_trial','R_trial','C_trial'})
% 'arglist' 
     % 'path' (default) cellbase path -> the path to the recording   
     % Trials_back -> default 11

     
% property_names 
    % C_trial   -> The choise history 
    % R_trial   -> The Reward history  

             
%% IC calculation - IC_refractary_period
    % add_analysis(@IC_refractary_period,1,'property_names',{'IC_percent'},'arglist',{'method','diff','refractory_p', 1});

% Calculates the amount of spike there violates the refractory period

% input
    % method -> "conv" / diff -> diff (default)
        % conv -> full conv in the given time range range
        % diff -> using the difference method will give a small underestiamte of the true spikes violating the refractory period 
        % refractory_p -> (ms) default 1 ms "the span from 0 ms to the value where the number of spikes violating the refractory period is calculated"  

% property_names
    % IC_percent -> "The percent of the total spikes for the neuron there violates the given refractory period"
    
    
%% Simularity score (NSSD) - NSSD_simularity_score

    % addanalysis(@NSSD_simularity_score,1,'property_names',{'score'},'mandatory',{'D:/recording','rezFinalK'})
   
% Calculates the simularity score (NSSD) of the "main" nueron to the rest of
% the neurons in the session of the "main" neuron 

% input
%    (1) the path the recording where the subfolders are each of the recorded animals
%    (2) The name of the rezfile where the template are saved. Must be saved in the session folder of the recording 

% output 
    % score -> the largest calculated NSSD score for the comparison analysis  
    
%% tagging_pv


%add_analysis(@tagging_pv,1,'property_names',{'pv','i_diff'},'arglist',{'event','BurstOn','window', [-0.1 0.2],'display',0});
     
%% check the saving of the timestamp of the neurons [CB, rez, TT] - timing_CB_recording

% addanalysis(@timing_CB_recording,'property_names',{'timing'},'mandatory',{'D:\recording','rezFinalK'});
    
% input
%    (1) the path to the recording where the subfolders are each of the recorded animals
%    (2) The name of the rezfile where the template are saved. Must be saved in the session folder of the recording 

% output 
    % timing -> True if both CB <-> rez and CB <-> TT mathces with the given corrections  
    



