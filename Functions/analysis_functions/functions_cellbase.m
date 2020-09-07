%The different functions created by Jesper Hagelskjær
% average_firing_Rate
% behaviour_neurons_kernels
% cellid2rezFile
% Choice_and_reward
% history_reward_choice
% IC_refractary_period
% NSSD_simularity_score
% tagging_pv (!)
% timing_CB_recording



%to run the different functions load the cellbase into the workspace and then run the different script given below
%some of the script requires access to other variable given in other script
%if they are not in these variable is not in the TheMatrix you will be
%asked to run the given script 

%% Average Firing rate in the centerport  - average_firing_Rate 

   % addanalysis(@average_firing_Rate,'property_names',{'CentralPortEpoch'},'mandatory',{'D:\recording'},'arglist',{'type', 'CentralPortEpoch'});

% NOTE
% The property_names and the 'type' in arglist must be the same name
     
% Calculates the average firing rate of the given neuron in the epoch  
   
% input
%    (1) the path to the recording where the subfolders are each of the recorded animals

% 'arglist' 
    % 'type' -> 
    %            CentralPortEpoch (default) average firing rate in the center port 
    %            Total_FR                   Total average firing of the neuron in the session   
    
% output 
    % the frequency of the neuron in the given epochs
  
%% Calculate the reward and choice coefficient for the behaviour 
 
    % addanalysis(@behaviour_neurons_kernels,'property_names',{'B_trial_neuron','p_trial_neuron'},'arglist',{'loops',1})

% 'arglist'
    % loops -> How many time is the elaticnet regression looped through the
    % behaviour data
    
% output
    % the coefficient for the behavior data
    
%% CellID to rez file - cellid2rezFile    

%addanalysis(@cellid2rezFile,'property_names',{'ID'},'mandatory',{'D:/recording','rezFinalK'}) 

% input
%    (1) the path the recording where the subfolders are each of the recorded animals
%    (2) The name of the rezfile where the template are saved. Must be saved in the session folder of the recording 

% output 
    % ID -> ingeter of the ID in the rez file       
%% The current choice and reward - Choice_and_reward

    % addanalysis(@Choice_and_reward,'property_names',{'CH','RH','Indices_to_erase'},'mandatory',{'D:\recording'})   

% Calcualte the choice and reward history of the animal. Will only calcualte it for the first neurons and set det rest to an emptu entry in the Matrix    
  %will you to much memory otherwise
  
% input
%    (1) the path the recording where the subfolders are each of the recorded animals

% output 
    % CH               -> The choice error trial (nan)
    % RH               -> The Reward error trial (nan)  
    % Indices_to_erase -> Behavior trials which failed 
    
%% The choice and reward history - Choice_and_reward history

% addanalysis(@history_reward_choice,'property_names',{'C_current_time','R_trial','C_trial'},'mandatory',{'D:\recording'},'arglist',{'Trials_back',11,'Time_back', 41,'dt',0.2})

% input
%    (1) the path the recording where the subfolders are each of the recorded animals

%arg
     % Trials_back -> default 11
     % Time_back   -> default 41  
     % dt          -> default 0.2
% output 
    % C_current_time   -> The choise history (A intry is -2 instead of nan)
    % R_trial          -> The Reward history (A intry is -2 instead of nan)  
    % Indices_to_erase -> Behavior trials which failed 
       
    
  % firing -> average firing rate (Hz) of the given neuron in the given epoch
    
%% check the saving of the timestamp of the neurons [CB, rez, TT] - timing_CB_recording

% addanalysis(@timing_CB_recording,'property_names',{'timing'},'mandatory',{'D:\recording','rezFinalK'});
    
% input
%    (1) the path to the recording where the subfolders are each of the recorded animals
%    (2) The name of the rezfile where the template are saved. Must be saved in the session folder of the recording 

% output 
    % timing -> True if both CB <-> rez and CB <-> TT mathces with the given corrections  
    
    
%% 


% history_reward_choice

%% IC calculation - IC_refractary_period
    % addanalysis(@IC_refractary_period,'property_names',{'IC_percent'},'arglist',{'refractory_p', 1});

% Calculates the amount of spike there violates the refractory period

% input
    % method -> "conv" / diff -> diff (default)
        % conv -> full conv in the given range
        % diff -> using the difference method will give a small underestiamte of the true spikes violating the refractory period 
    % refractory_p -> (ms) default 1 ms "the span from 0 ms to the value where the number of spikes violating the refractory period is calculated"  

% output
    % IC_percent -> "The percent of the total spikes for the neuron there violates the given refractory period"
    
    
%% Simularity score (NSSD) - NSSD_simularity_score

    % addanalysis(@NSSD_simularity_score,'property_names',{'score'},'mandatory',{'D:/recording','rezFinalK'})
   
% Calculates the simularity score (NSSD) of the "main" nueron to the rest of
% the neurons in the session of the "main" neuron 

% input
%    (1) the path the recording where the subfolders are each of the recorded animals
%    (2) The name of the rezfile where the template are saved. Must be saved in the session folder of the recording 

% output 
    % score -> the largest calculated NSSD score for the comparison analysis 


%% tagging_pv


%addanalysis(@tagging_pv,'property_names',{'pv','i_diff'},'mandatory',{'D:\recording'},'arglist',{'event','BurstOn','window', [-0.1 0.2],'display',0});


 