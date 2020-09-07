clear all
% close all
Trial2Del = 5;
CurrentFolder = cd;
Session = dir;
Session = Session(3:end);
iTrials = 3;
StayT = NaN(length(Session),iTrials);
SwitchT = NaN(length(Session),iTrials);
RewStayT = NaN(length(Session),iTrials);
RewSwitchT = NaN(length(Session),iTrials);
NonRewStayT = NaN(length(Session),iTrials);
NonRewSwitchT = NaN(length(Session),iTrials);

Protocol = 'Factor' ; % 'Factor' 'BlockLength'

switch Protocol
    
    case 'Factor'
        for isess = 1:length(Session)   %:length(Session)
            sessionpath = [CurrentFolder '\' Session(isess).name];
            [CH, RH, TrialTypes, TrialLength] = Collect_BaitingFactor(sessionpath,Trial2Del);
            
            %initialize the variables  for rewarded switch and stay
            RewStay = NaN(1,length(CH));
            RewSwitch = NaN(1,length(CH));
            NonRewStay = NaN(1,length(CH));
            NonRewSwitch = NaN(1,length(CH));
            
            %Shift RH and CH with one place
            CH_Shift = [CH(2:end) NaN];
            RH_Shift = [RH(2:end) NaN];
            
            %Logicals of stay vs shift
            Stay  = CH_Shift == CH;
            Switch = CH_Shift ~= CH;
            
            %Stay vs switch after reward
            RTrials = abs(RH);
            
            RewStay = RTrials == 1 & Stay == 1;
            RewSwitch = RTrials == 1 & Stay == 0;
            NonRewStay = RTrials == 0 & Stay == 1;
            NonRewSwitch = RTrials == 0 & Stay == 0;
            
            for i = 1:iTrials
                StayT(isess,i) = nansum(Stay(TrialTypes ==i))/length((Stay(TrialTypes ==i)));
                SwitchT(isess,i) = 1 - StayT(isess,i);
                RewStayT(isess,i) = nansum(RewStay(TrialTypes ==i))/sum((RTrials(TrialTypes ==i)));
                RewSwitchT(isess,i) = 1-RewStayT(isess,i);
                NonRewStayT(isess,i) = nansum(NonRewStay(TrialTypes ==i))/sum( 1 - (RTrials(TrialTypes ==i)));
                NonRewSwitchT(isess,i) = 1-NonRewStayT(isess,i);
            end
            
            %Plots
            figure
            subplot(3,1,1);
            bar([StayT(isess,:)' SwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
            subplot(3,1,2);
            bar([RewStayT(isess,:)'  RewSwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
            subplot(3,1,3);
            bar([NonRewStayT(isess,:)' NonRewSwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
        clear Stay Switch    
            
        end
        
    case 'BlockLength'
        for isess = 1:length(Session)   %:length(Session)
            sessionpath = [CurrentFolder '\' Session(isess).name];
            [CH, RH, TrialLength] = Collect_TrialLength(sessionpath,Trial2Del);
            
            %initialize the variables
            RewStay = NaN(1,length(CH));
            RewSwitch = NaN(1,length(CH));
            NonRewStay = NaN(1,length(CH));
            NonRewSwitch = NaN(1,length(CH));
            BlockTypes = NaN(1,length(TrialLength));
            
            
                    
            %Shift RH and CH with one place
            CH_Shift = [CH(2:end) NaN];
            RH_Shift = [RH(2:end) NaN];
            
            %Logicals of stay vs shift
            Stay  = CH_Shift == CH;
            Switch = CH_Shift ~= CH;
            
            %Stay vs switch after reward
            RTrials = abs(RH);
            
            RewStay = RTrials == 1 & Stay == 1;
            RewSwitch = RTrials == 1 & Stay == 0;
            NonRewStay = RTrials == 0 & Stay == 1;
            NonRewSwitch = RTrials == 0 & Stay == 0;
            
            %Create trial types based on block length
            Tercile1 = prctile(unique(TrialLength),33);
            Tercile2 = prctile(unique(TrialLength),66);
            
            BlockTypes(TrialLength <= Tercile1) = 1;
            BlockTypes(TrialLength > Tercile1 & TrialLength <= Tercile2) = 2;
            BlockTypes(TrialLength > Tercile2) = 3;
                      
            for i = 1:iTrials
                StayT(isess,i) = nansum(Stay(BlockTypes ==i))/length((Stay(BlockTypes ==i)));
                SwitchT(isess,i) = 1 - StayT(isess,i);
                RewStayT(isess,i) = nansum(RewStay(BlockTypes ==i))/sum((RTrials(BlockTypes ==i)));
                RewSwitchT(isess,i) = 1-RewStayT(isess,i);
                NonRewStayT(isess,i) = nansum(NonRewStay(BlockTypes ==i))/sum( 1 - (RTrials(BlockTypes ==i)));
                NonRewSwitchT(isess,i) = 1-NonRewStayT(isess,i);
            end
        
            %Plots
            figure
            subplot(3,1,1);
            bar([StayT(isess,:)' SwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
            subplot(3,1,2);
            bar([RewStayT(isess,:)'  RewSwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
            subplot(3,1,3);
            bar([NonRewStayT(isess,:)' NonRewSwitchT(isess,:)']);
            axis([0.5 3.5 0 1])
            
            clear Stay Switch
            
        end
end

figure
boxplot([StayT(:,1),StayT(:,2), StayT(:,3),RewStayT(:,1),RewStayT(:,2), RewStayT(:,3),NonRewStayT(:,1),NonRewStayT(:,2), NonRewStayT(:,3)])


