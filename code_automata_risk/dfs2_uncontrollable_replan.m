function [Stack1,Stack2,States,Transitions,depth2,counter,done] = dfs2_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,new_state,F_share,seed,depth2,max1,max2,counter,W,done)
    
    null = 1;
    one = 2;
    depth2 = depth2+1;
    Stack2 = horzcat(Stack2,{new_state});
    global Parameter
    if length(States)==1
        States{one}{1} = new_state;
    else
        States{one} = horzcat(States{one},{new_state});
    end
    
    i_RA = find(strcmp(RA.S,new_state)==1);
    if ((i_RA>length(RA.Delta)) || (isempty(RA.Delta{i_RA}))) % To take care of deadlock states, no transitions from here
        % Do nothing
        error('should this happen?')
    else
        for i=1:length(RA.Delta{i_RA})
            if done==1
                break
            end
            if ~strcmp(RA.Delta{i_RA},'blocking') % May be redundant, could be removed potentially
                i_RA_next = find(strcmp(RA.S,RA.Delta{i_RA}{i}.ss)==1);
                if check_feasible_transitions(RA.lambda_s{i_RA},RA.lambda_e{i_RA}{i},RA.lambda_s{i_RA_next}) && ... % I might make a mistake here and loose completeness       
                    strcmp(RA.lambda_e{i_RA}{i}{Parameter.ind},'-p5') && sum(strcmp(RA.Delta{i_RA}{i}.ss,W))==1 
        %             if length(Transitions)==1
        %                 Transitions{one}{1} = {{RA.S{i_RA},RA.lambda_e{i_RA}{i},RA.Delta{i_RA}{i}.ss}};
        %             else 
        %                 Transitions{one} =  horzcat(Transitions{one},{{RA.S{i_RA},RA.lambda_e{i_RA}{i},RA.Delta{i_RA}{i}.ss}});
        %             end
                    counter = counter + 1;
                    if sum(strcmp(RA.Delta{i_RA}{i}.ss,seed))
                        Stack2 = horzcat(Stack2,RA.Delta{i_RA}{i}.ss);
                        labels = get_labels(RA,Stack1,Stack2);
                        Parameter.labels = labels;
                        Parameter.states = [Stack1,Stack2{2:end-1}];
                        %testing()
                        done = 1;
                        %ind = find(strcmp(Stack2,RA.Delta{i_RA}{i}.ss));
                    elseif ~sum(strcmp(States{one},RA.Delta{i_RA}{i}.ss)) && length(Stack2)<=max2
                    %elseif ~sum(strcmp(Stack2,RA.Delta{i_RA}{i}.ss)) && length(Stack2)<=max2 
                        [Stack1,Stack2,States,Transitions,depth2,counter,done]=dfs2_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,RA.Delta{i_RA}{i}.ss,F_share,seed,depth2,max1,max2,counter,W,done);
                    end
                end
            end
        end
    end
    
    % delete s from Stack 2
    if done==0
        ind = find(strcmp(Stack2,new_state));
        Stack2(ind)=[];
    end
    
    depth2=depth2-1;
end