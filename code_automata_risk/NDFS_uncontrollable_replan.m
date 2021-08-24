function path = NDFS_uncontrollable_replan(RA,max1,max2,variant,W,state,d)
    global Parameter
    % Find common accepting states
    if d
        b=[];
        F_share=[];
        for i=1:length(RA.F{1})
            ind = 1;
            if length(RA.F)==1
                F_share = RA.F;
                break
            else
                for j=2:length(RA.F)
                    if ~sum(strcmp(RA.F{1}{i},RA.F{j}))
                        break
                    end
                    if j==length(RA.F)
                        b = [b i];
                    end
                end
            end
        end

        if length(RA.F)>1
            F_share = RA.F{1}(b);
        end
    else
        F_share = RA.F{1}; % in this case, each state is accepting (no until operator included)
    end
    
    if isempty(F_share)
        % Do NDFS for generalized Buchi acceptance condition
        error('Not implemented yet');
    else % Try NDFS for Buchi acceptance condition 
        i_RA_replan = find(strcmp(RA.S,state)==1);

        null = 1;
        one = 2;
        Stack1{1}= RA.S{i_RA_replan};
        Stack2{1}= 'none';
        States{null}{1} = RA.S{i_RA_replan};
        depth1 = 1;
        depth2 = 1;
        counter = 1;
        done = 0;
        % RA.S{1} can not be accepting, so no need to check for variant 1

        if RA.zeno{i_RA_replan}==1
            error('no uncontrollable signal can technically occur here');
        end
        
        for i=1:length(RA.Delta{i_RA_replan})
            i_RA_next = find(strcmp(RA.S,RA.Delta{i_RA_replan}{i}.ss)==1);
            Transitions{null}{i} =  {{RA.S{i_RA_replan}},RA.lambda_e{i_RA_replan}{i},{RA.Delta{i_RA_replan}{i}.ss}};
            if ~sum(strcmp(States{null},RA.Delta{i_RA_replan}{i}.ss)) && sum(strcmp(RA.Delta{i_RA_replan}{i}.ss,W))==1 && ...
                    strcmp(RA.lambda_e{i_RA_replan}{i}{Parameter.ind},'p5') %Here p5 is required!
            %if ~sum(strcmp(Stack1,RA.Delta{1}{i}.ss))
                if done==1
                    break
                end
                [Stack1,Stack2,States,Transitions,depth1,depth2,counter,done]=dfs1_uncontrollable_replan(RA,Stack1,Stack2,States,Transitions,RA.Delta{i_RA_replan}{i}.ss,F_share,depth1,depth2,max1,max2,variant,counter,W,done);
            end
        end
    
        % RA.S{1} can not be accepting, so no need to check for variant 2
        if done==0
            error('No cycle found')
        end
    end
    
    path = {Parameter.states, Parameter.labels};
end