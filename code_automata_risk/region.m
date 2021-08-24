function RA = region(ST,p_init,zeta)
    global Parameter
    RA = RegionAutomaton;
    RA.Lambda = ST.Lambda;
    RA.Gamma = ST.Gamma;
    RA.b = ST.b;
    RA.c = ST.c;
    
    % Find all clocks and clock constants
    Nc = 0; %number of real clocks
    for i=1:length(ST.c)
        if ~strcmp(ST.c{i},'none')
            Nc = Nc + 1;
            C(Nc) = str2num(ST.b{i}); % All Clock constants
            if strcmp(ST.c{i},'c11')
                pp(Nc,1) = zeta;
            else
                pp(Nc,1) = 0;
            end
        end
    end
    
    % Forward Simulation - Initial step
    counter = 1; %number of states
    F_ind = zeros(1,length(ST.F));
    RA.S{counter} = ['r' num2str(counter-1)];
    RA.state{counter} = ST.S{1}; % Indicate signal transducer state 
    RA.reg{counter} = diag(pp); % Indicate clock region
    RA.iota{counter}=ST.iota{1};
    RA.lambda_s{counter}=ST.lambda_s{1};
    RA.gamma_s{counter}=ST.gamma_s{1};
    RA.zeno{counter}=1;
    RA.p{1}=pp;
    counter = counter + 1;
%     [sr,p,p0] = find_successors(RA,Nc,1,C);
%     [b,z] = check_reactivity(ST,1,p0,T,C,0,1); % Does not need to be
%     checked because of Zeno avoidance
    for i=1:length(ST.Delta{1}) % These transitions always exist, no guards/invariants need to be checked
        i_ST_next = find(strcmp(ST.Delta{1}{i}.ss,ST.S));
        if strcmp(ST.gamma_e{1}{i},'q') &&... %Otherwise we are not interested in this transition anyways
                check_input_labels(p_init,ST.lambda_s{i_ST_next}) ...
                    && check_input_labels(p_init,ST.lambda_e{1}{i})  %Only pick those initial transitions/states that will lead to formula satisfaction and are in line with initial condition
            RA.S{counter} = ['r' num2str(counter-1)];
            RA.state{counter} = ST.Delta{1}{i}.ss;
            RA = initial_clock_zones(ST,RA,Nc,counter,i);
            % Wire and label new states correctly
            RA.iota{counter}=ST.iota{i_ST_next};
            RA.Delta{1}{counter-1}.s=RA.S{1};
            RA.Delta{1}{counter-1}.ss=RA.S{counter};
            RA.Delta{1}{counter-1}.g=ST.Delta{1}{i}.g;
            RA.Delta{1}{counter-1}.R=ST.Delta{1}{i}.R;
            RA.lambda_s{counter}=ST.lambda_s{i_ST_next};
            RA.gamma_s{counter}=ST.gamma_s{i_ST_next};
            RA.lambda_e{1}{counter-1}=ST.lambda_e{1}{i};
            RA.gamma_e{1}{counter-1}=ST.gamma_e{1}{i};
            %RA.Prev{counter}=RA.S{1}; %Used for game-based approach later
            RA.type{1}{counter-1}={'d'};
            RA.flow_time{1}{counter-1}=0;
            % Buchi condition
            for l=1:length(ST.F)
                if sum(strcmp(RA.state{counter},ST.F{l}))
                    if F_ind(l)==0
                        RA.F{l}{1}=RA.S{counter};
                        F_ind(l) = 1;
                    else
                        ll = length(RA.F{l});
                        RA.F{l}{ll+1}=RA.S{counter};
                    end
                end
            end
            counter = counter + 1;
        end
    end
    
    % Forward Simulation - Loop
    keep_going = 1; %termination criterion
    start = 2;
    stop = length(RA.S);
    while keep_going==1 
        for i=start:stop
            ind_=1; % indicates outgoing transitions from this state
            bb=1; %indicates deadlocks
            % Check time and discrete transitions
            i_ST=find(strcmp(RA.state{i},ST.S)); % i_ST in ST corresponds to i in RA
            [sr,p,p0] = find_successors(RA,Nc,i,C); % Should also the current state be a successor (this could lead to zeno)?
            RA.p{i}=p0;
            % Time and discrete Transitions
            cc = check_invariant(ST.c,ST.iota{i_ST},ST.iota{i_ST},p(:,1),p(:,1),C); % The purpose of this and the next line is to cover cases where for -p5 a continuation is possible
            [ccc,list] = check_flow_into_guard(ST,i_ST,p(:,1),C);
            [b,z] = check_reactivity(ST,i_ST,p0,C,cc,ccc,list);
            RA.zeno{i} = z;
            if b % either 1) transition for each uncontrollable proposition or 2) there exists a successor region I can flow/jump into if no uncontrollable events occur/Zeno excluded
                % time transition
                if cc
                    bb=0;
                    [b,ss] = check_ambiguous_states(RA,RA.state{i},sr{1});
                    if b
                        RA.S{counter} = ['r' num2str(counter-1)];
                        RA.state{counter} = RA.state{i};
                        RA.reg{counter} = sr{1};
                        % Wire and label new states correctly
                        RA.iota{counter}=ST.iota{i_ST};
                        RA.Delta{i}{ind_}.s=RA.S{i};
                        RA.Delta{i}{ind_}.ss=RA.S{counter};
                        g = cell(1,length(RA.Delta{1}{1}.g));
                        g(:) = {'c0'};
                        RA.Delta{i}{ind_}.g=g;
                        R = cell(1,length(RA.Delta{1}{1}.R));
                        R(:) = {'r0'};
                        RA.Delta{i}{ind_}.R=R;
                        RA.lambda_s{counter}=ST.lambda_s{i_ST};
                        RA.gamma_s{counter}=ST.gamma_s{i_ST};
                        RA.lambda_e{i}{ind_}=ST.lambda_s{i_ST};
                        RA.gamma_e{i}{ind_}=ST.gamma_s{i_ST};
                        RA.type{i}{ind_}={'t'};
                        RA.flow_time{i}{ind_}=max(p(:,1)-p0);
                        ind_ = ind_ + 1;
                        %RA.Prev{counter}=RA.S{i}; %Used for game-based approach later                       
                        % Buchi condition
                        for l=1:length(ST.F)
                            if sum(strcmp(RA.state{counter},ST.F{l}))
                                if F_ind(l)==0
                                    RA.F{l}{1}=RA.S{counter};
                                    F_ind(l) = 1;
                                else
                                    ll = length(RA.F{l});
                                    RA.F{l}{ll+1}=RA.S{counter};
                                end
                            end
                        end

                        counter = counter + 1;

                    else % Only add transition, next state already exists
                        RA.Delta{i}{ind_}.s=RA.S{i};
                        RA.Delta{i}{ind_}.ss=RA.S{ss};
                        g = cell(1,length(RA.Delta{1}{1}.g));
                        g(:) = {'c0'};
                        RA.Delta{i}{ind_}.g=g;
                        R = cell(1,length(RA.Delta{1}{1}.R));
                        R(:) = {'r0'};
                        RA.Delta{i}{ind_}.R=R;
                        RA.lambda_e{i}{ind_}=ST.lambda_s{i_ST};
                        RA.gamma_e{i}{ind_}=ST.gamma_s{i_ST};
                        %i_ST_next = find(strcmp(RA.S{ss},RA.S));
                        %RA.Prev{i_ST_next}=RA.S{i}; %Used for game-based approach later
                        RA.type{i}{ind_}={'t'};
                        RA.flow_time{i}{ind_}=max(p(:,1)-p0);
                        ind_ = ind_ + 1;
                    end
                end

                % Discrete Step (Transition)
                for k=1:length(ST.Delta{i_ST}) % Check all transitions from i
                    i_ST_next = find(strcmp(ST.Delta{i_ST}{k}.ss,ST.S));
                    if check_guard(ST.c,ST.Delta{i_ST}{k},p0,C) && ...
                        check_reactive_transition(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) && ...
                        check_feasible_transitions(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) 
                        [sr_next,p_next] = calc_reset(ST.c,ST.Delta{i_ST}{k},p0,Nc);
                        [b,ss] = check_ambiguous_states(RA,ST.Delta{i_ST}{k}.ss,sr_next);
                        bb = 0;
                        if b % Next state does not exist yet
                            i_ST_next = find(strcmp(ST.Delta{i_ST}{k}.ss,ST.S));
                            % Then set resets and form new states if applicable
                            RA.S{counter} = ['r' num2str(counter-1)];
                            RA.state{counter} = ST.Delta{i_ST}{k}.ss;
                            RA.reg{counter} = sr_next;  
                            % Wire and label new states correctly
                            RA.iota{counter}=ST.iota{i_ST_next};
                            RA.Delta{i}{ind_}.s=RA.S{i};
                            RA.Delta{i}{ind_}.ss=RA.S{counter};
                            RA.Delta{i}{ind_}.g=ST.Delta{i_ST}{k}.g;
                            RA.Delta{i}{ind_}.R=ST.Delta{i_ST}{k}.R;
                            RA.lambda_s{counter}=ST.lambda_s{i_ST_next};
                            RA.gamma_s{counter}=ST.gamma_s{i_ST_next};
                            RA.lambda_e{i}{ind_}=ST.lambda_e{i_ST}{k};
                            RA.gamma_e{i}{ind_}=ST.gamma_e{i_ST}{k};
                            RA.type{i}{ind_}={'d'};
                            RA.flow_time{i}{ind_}=0;
                            ind_ = ind_ + 1;
                            %RA.Prev{counter}=RA.S{i}; %Used for game-based approach later
                            % Buchi condition
                            for l=1:length(ST.F)
                                if sum(strcmp(RA.state{counter},ST.F{l}))
                                    if F_ind(l)==0
                                        RA.F{l}{1}=RA.S{counter};
                                        F_ind(l) = 1;
                                    else
                                        ll = length(RA.F{l});
                                        RA.F{l}{ll+1}=RA.S{counter};
                                    end
                                end
                            end

                            counter = counter + 1;

                        else % Only add transition, next state already exists
                            RA.Delta{i}{ind_}.s=RA.S{i};
                            RA.Delta{i}{ind_}.ss=RA.S{ss};
                            RA.Delta{i}{ind_}.g=ST.Delta{i_ST}{k}.g;
                            RA.Delta{i}{ind_}.R=ST.Delta{i_ST}{k}.R; 
                            RA.lambda_e{i}{ind_}=ST.lambda_e{i_ST}{k};
                            RA.gamma_e{i}{ind_}=ST.gamma_e{i_ST}{k};
                            %i_ST_next = find(strcmp(RA.S{ss},RA.S));
                            % RA.Prev{i_ST_next}=RA.S{i}; %Used for game-based approach later
                            RA.type{i}{ind_}={'d'};
                            RA.flow_time{i}{ind_}=0;
                            ind_ = ind_ + 1;
                        end
                    end 
                end
                
                % Flow till end of region + Discrete Step (Transition)
                if ccc % some transitions may now occur twice
                    for k=1:length(ST.Delta{i_ST}) % Check all transitions from i
                        i_ST_next = find(strcmp(ST.Delta{i_ST}{k}.ss,ST.S));
                        if check_guard(ST.c,ST.Delta{i_ST}{k},p(:,1),C) && ...  % transition satisfied that we may flow into
                            check_reactive_transition(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) && ...
                            check_feasible_transitions(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) %&& ...
                            %check_reactivity_td(ST,i_ST,p0,C,ST.lambda_e{i_ST}{k}) % I might lose sth here
                            [sr_next,p_next] = calc_reset(ST.c,ST.Delta{i_ST}{k},p(:,1),Nc);
                            [b,ss] = check_ambiguous_states(RA,ST.Delta{i_ST}{k}.ss,sr_next);
                            bb = 0;
                            if b % Next state does not exist yet
                                i_ST_next = find(strcmp(ST.Delta{i_ST}{k}.ss,ST.S));
                                % Then set resets and form new states if applicable
                                RA.S{counter} = ['r' num2str(counter-1)];
                                RA.state{counter} = ST.Delta{i_ST}{k}.ss;
                                RA.reg{counter} = sr_next;
                                % Wire and label new states correctly
                                RA.iota{counter}=ST.iota{i_ST_next};
                                RA.Delta{i}{ind_}.s=RA.S{i};
                                RA.Delta{i}{ind_}.ss=RA.S{counter};
                                RA.Delta{i}{ind_}.g=ST.Delta{i_ST}{k}.g;
                                RA.Delta{i}{ind_}.R=ST.Delta{i_ST}{k}.R;
                                RA.lambda_s{counter}=ST.lambda_s{i_ST_next};
                                RA.gamma_s{counter}=ST.gamma_s{i_ST_next};
                                RA.lambda_e{i}{ind_}=ST.lambda_e{i_ST}{k};
                                RA.gamma_e{i}{ind_}=ST.gamma_e{i_ST}{k};
                                RA.type{i}{ind_}={'td'};
                                RA.flow_time{i}{ind_}=max(p(:,1)-p0);
                                ind_ = ind_ + 1;
                                %RA.Prev{counter}=RA.S{i}; %Used for game-based approach later
                                % Buchi condition
                                for l=1:length(ST.F)
                                    if sum(strcmp(RA.state{counter},ST.F{l}))
                                        if F_ind(l)==0
                                            RA.F{l}{1}=RA.S{counter};
                                            F_ind(l) = 1;
                                        else
                                            ll = length(RA.F{l});
                                            RA.F{l}{ll+1}=RA.S{counter};
                                        end
                                    end
                                end

                                counter = counter + 1;

                            else % Only add transition, next state already exists
                                RA.Delta{i}{ind_}.s=RA.S{i};
                                RA.Delta{i}{ind_}.ss=RA.S{ss};
                                RA.Delta{i}{ind_}.g=ST.Delta{i_ST}{k}.g;
                                RA.Delta{i}{ind_}.R=ST.Delta{i_ST}{k}.R; 
                                RA.lambda_e{i}{ind_}=ST.lambda_e{i_ST}{k};
                                RA.gamma_e{i}{ind_}=ST.gamma_e{i_ST}{k};
                                %i_ST_next = find(strcmp(RA.S{ss},RA.S));
                                % RA.Prev{i_ST_next}=RA.S{i}; %Used for game-based approach later
                                RA.type{i}{ind_}={'td'};
                                RA.flow_time{i}{ind_}=max(p(:,1)-p0);
                                ind_ = ind_ + 1;
                            end
                        end 
                    end
                end
            end  
            

            if bb==1
                RA.Delta{i}={'blocking'}; % Mark blocking states as such (no transition from here)
            end    

        end
      
        % Check termination
        if i==stop && stop==length(RA.S)
            keep_going=0;
        else
            start = stop + 1;
            stop = length(RA.S);
        end
    end
end


% Each clock has 4 states (diagonal):
% 0:    0
% 0.5:  (0,1)
% 1:    1
% 1.5:  (1,2)
% 2:    2

% Relation of clocks (upper diagonal):
% 0: no meaning, indicates this is not needed for this clock pair
% 1: row "greater" than column
% 2: row "equal" to column
% 3: row "smaller" than column