function [Stack1,Stack2,States,Transitions,depth1,depth2,counter,done] = dfs1_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,new_state,F_share,depth1,depth2,max1,max2,variant,counter,W,done)
    
    null = 1;
    one = 2;
    depth1 = depth1+1;
    Stack1 = horzcat(Stack1,{new_state});
    States{null} = horzcat(States{null},{new_state});
    global Parameter
    
    if sum(strcmp(F_share,new_state)) && variant == 1
        seed = new_state;
        States{one} = {};
        [Stack1,Stack2,States,Transitions,depth2,counter,done]=dfs2_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,new_state,F_share,seed,depth2,max1,max2,counter,W,done);
    end
    
    i_RA = find(strcmp(RA.S,new_state)==1);
    if ((i_RA>length(RA.Delta)) || (isempty(RA.Delta{i_RA}))) % To take care of deadlock states, no transitions from here
        % Do nothing
        error('should this happen in the new version?')
    else
        for i=1:length(RA.Delta{i_RA})
            if done==1
                break
            end
            if ~strcmp(RA.Delta{i_RA},'blocking') % may be redundante when supervisory controller is employed
                i_RA_next = find(strcmp(RA.S,RA.Delta{i_RA}{i}.ss)==1); % I might make a mistake here and loose completeness
                if check_feasible_transitions(RA.lambda_s{i_RA},RA.lambda_e{i_RA}{i},RA.lambda_s{i_RA_next}) % redundancy here due to the definition of the function
        %             Transitions{null} =  horzcat(Transitions{null},{{RA.S{i_RA},RA.lambda_e{i_RA}{i},RA.Delta{i_RA}{i}.ss}});
                    ii = find(strcmp(RA.Delta{i_RA}{i}.ss,RA.S)==1);
                    if ~sum(strcmp(States{null},RA.Delta{i_RA}{i}.ss)) && length(Stack1)<=max1 && ...  
                        sum(strcmp(RA.Delta{i_RA}{i}.ss,W))==1 && strcmp(RA.lambda_e{i_RA}{i}{Parameter.ind},'-p5') %&& ...
                        %(strcmp(RA.lambda_s{ii}{1},'-p2') || strcmp(RA.lambda_s{ii}{5},'p6') || indd) 
%                         if strcmp(RA.lambda_s{ii}{1},'p6')
%                             indd=1;
%                         end
                        [Stack1,Stack2,States,Transitions,depth1,depth2,counter,done]=dfs1_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,RA.Delta{i_RA}{i}.ss,F_share,depth1,depth2,max1,max2,variant,counter,W,done);
                    end
                end
            end
        end
    end
    
    
    if sum(strcmp(F_share,new_state)) && variant == 2 
        seed = new_state;
        [Stack1,Stack2,States,Transitions,depth2,counter,done]=dfs2_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,new_state,F_share,seed,depth2,max1,max2,counter,W,done);
    end
    
    % delete s from Stack 1
    if done==0
        ind = find(strcmp(Stack1,new_state));
        Stack1(ind)=[];
    end
    
    depth1=depth1-1;
    
end