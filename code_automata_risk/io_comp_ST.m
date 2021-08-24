function ST = io_comp_ST(ST1,ST2) % Input output composition acc. to ST2(ST1)
    ST = SignalTransducer;
    
    % Input Label
    ST.Lambda = ST1.ST.Lambda;
    
    % Input Label
    ST.Gamma = ST2.ST.Gamma;
    
    % Clocks
    ST.c = horzcat(ST1.ST.c,ST2.ST.c);
    
    % Times
    ST.b = horzcat(ST1.ST.b,ST2.ST.b);
    
    % Initialize
    ST.F = cell(1,length(ST1.ST.F)+length(ST2.ST.F));
    
    % States
    counter = 1;
    for i=1:length(ST1.ST.S)
        for j=1:length(ST2.ST.S)
            if  ((i==1 && j~=1) || (j==1 && i~=1))
                % No new state, this state won't be reached (recall that
                % i==1 or j==1 indicates initial states of subsystems
            elseif ~(i==1 && j==1) && ~check_labels(ST1.ST.gamma_s{i},ST2.ST.lambda_s{j})
                % No new state, input/output labels don't match
                % First part of condition is excludes initial state
            else
                if operation1(horzcat(ST1.ST.lambda_s{i},ST2.ST.lambda_s{j})) && operation3(horzcat(ST1.ST.lambda_s{i},ST2.ST.lambda_s{j})) && ... % Remove physically infeasible new states
                    check_double_propositions(horzcat(ST1.ST.lambda_s{i},ST2.ST.lambda_s{j}))
                    % Create new State
                    ST.S{counter} = ['s' num2str(counter-1)];
                    prev_states(:,counter) = [i;j];

                    % Create state input label
                    ST.lambda_s{counter} = ST1.ST.lambda_s{i};

                    % Create state output label
                    ST.gamma_s{counter} = ST2.ST.gamma_s{j};

                    % Invariants
                    ST.iota{counter} = horzcat(ST1.ST.iota{i},ST2.ST.iota{j});

                    % Acceptance Condition
                    for k=1:length(ST1.ST.F)
                        if find(strcmp(ST1.ST.F{k},['s' num2str(i-1)]))
                            if isempty(ST.F{k})
                                ST.F{k} = {ST.S{counter}};
                            else
                                ST.F{k} = horzcat(ST.F{k},{ST.S{counter}});
                            end
                        end
                    end
                    for k=1:length(ST2.ST.F)
                        if find(strcmp(ST2.ST.F{k},['s' num2str(j-1)]))
                            if isempty(ST.F{k+length(ST1.ST.F)})
                                ST.F{k+length(ST1.ST.F)} = {ST.S{counter}};
                            else
                                ST.F{k+length(ST1.ST.F)} = horzcat(ST.F{k+length(ST1.ST.F)},{ST.S{counter}});
                            end
                        end
                    end

                    % Next newly combined state
                    counter = counter + 1;
                end
            end
        end
    end
    
    
    % Check transitions between new states si and sj (in both directions)
    for i=1:length(ST.S) 
        counter = 1;
        for j=1:length(ST.S)
            for k=1:length(ST1.ST.Delta{prev_states(1,i)}) %Look at each edge of subsystem 1 starting in i!
                % Simultaneous and left-sided transitions
                if strcmp(ST1.ST.Delta{prev_states(1,i)}{k}.ss,ST1.ST.S{prev_states(1,j)}) %This particular edge of subsystem 1 goes to j!
                    % Left-sided transition
                    if ~isempty(ST1.ST.gamma_e{prev_states(1,i)})&&...
                            strcmp(ST2.ST.S{prev_states(2,i)},ST2.ST.S{prev_states(2,j)}) && i~=1 % Subsystem 2 needs to stay in the same state (exclude staying in initial states)
                        if ~check_labels(ST1.ST.gamma_e{prev_states(1,i)}{k},ST2.ST.lambda_s{prev_states(2,i)})
                            % No new left-sided transition
                        else
                            R2    = cell(1, length(ST2.ST.c));
                            R2(:) = {'r0'};
                            if compare_clock(ST1.ST.c,ST2.ST.c,ST1.ST.Delta{prev_states(1,i)}{k}.R,R2)
                                g = horzcat(ST1.ST.Delta{prev_states(1,i)}{k}.g,ST2.ST.iota{prev_states(2,i)});
                                R = horzcat(ST1.ST.Delta{prev_states(1,i)}{k}.R,R2);
                                e = Edge(['s' num2str(i-1)],['s' num2str(j-1)],g,R);
                                ST.Delta{i}{counter} = e;
                                ST.lambda_e{i}{counter} = ST1.ST.lambda_e{prev_states(1,i)}{k};
                                ST.gamma_e{i}{counter} = ST2.ST.gamma_s{prev_states(2,i)};
                                counter = counter + 1; 
                            end
                        end
                    end
                    % Simultaneous transition
                    for l=1:length(ST2.ST.Delta{prev_states(2,i)}) %Now look at each edge of subsystem 2 starting in i!
                        if ~isempty(ST1.ST.gamma_e{prev_states(1,i)})&&~isempty(ST2.ST.gamma_e{prev_states(2,i)})&&...
                                strcmp(ST2.ST.Delta{prev_states(2,i)}{l}.ss,ST2.ST.S{prev_states(2,j)})  %This edge of subsystem 2 goes also to j!
                            if ~check_labels(ST1.ST.gamma_e{prev_states(1,i)}{k},ST2.ST.lambda_e{prev_states(2,i)}{l})
                                % No new simultaneous transition
                            else
                                if compare_clock(ST1.ST.c,ST2.ST.c,ST1.ST.Delta{prev_states(1,i)}{k}.R,ST2.ST.Delta{prev_states(2,i)}{l}.R)
                                    g = horzcat(ST1.ST.Delta{prev_states(1,i)}{k}.g,ST2.ST.Delta{prev_states(2,i)}{l}.g);
                                    R = horzcat(ST1.ST.Delta{prev_states(1,i)}{k}.R,ST2.ST.Delta{prev_states(2,i)}{l}.R);
                                    e = Edge(['s' num2str(i-1)],['s' num2str(j-1)],g,R);
                                    ST.Delta{i}{counter} = e;
                                    ST.lambda_e{i}{counter} = ST1.ST.lambda_e{prev_states(1,i)}{k};
                                    ST.gamma_e{i}{counter} = ST2.ST.gamma_e{prev_states(2,i)}{l};
                                    counter = counter + 1;
                                end
                            end
                        end
                    end
                end   
            end
            % Right-sided transition
            for k=1:length(ST2.ST.Delta{prev_states(2,i)}) %Look at each edge of subsystem 2 starting in i!
                if strcmp(ST2.ST.Delta{prev_states(2,i)}{k}.ss,ST2.ST.S{prev_states(2,j)}) %This particular edge of subsystem 2 goes to j!
                    if ~isempty(ST2.ST.lambda_e{prev_states(2,i)})&&...
                            strcmp(ST1.ST.S{prev_states(1,i)},ST1.ST.S{prev_states(1,j)}) && i~=1 % Subsystem 1 needs to stay in the same state (exclude staying in initial states)
                        if ~check_labels(ST1.ST.gamma_s{prev_states(1,i)},ST2.ST.lambda_e{prev_states(2,i)}{k})   
                            % No new right-sided transition
                        else
                            R1    = cell(1, length(ST1.ST.c));
                            R1(:) = {'r0'};
                            if compare_clock(ST1.ST.c,ST2.ST.c,R1,ST2.ST.Delta{prev_states(2,i)}{k}.R)
                                g = horzcat(ST1.ST.iota{prev_states(1,i)},ST2.ST.Delta{prev_states(2,i)}{k}.g);
                                R = horzcat(R1,ST2.ST.Delta{prev_states(2,i)}{k}.R);
                                e = Edge(['s' num2str(i-1)],['s' num2str(j-1)],g,R);
                                ST.Delta{i}{counter} = e;
                                ST.lambda_e{i}{counter} = ST1.ST.lambda_s{prev_states(1,i)};
                                ST.gamma_e{i}{counter} = ST2.ST.gamma_e{prev_states(2,i)}{k};
                                counter = counter + 1; 
                            end
                        end
                    end
                end  
            end
   
            % Acceptance Condition (Do I need this for edges? I might get conservative, although sound, if I neglect them...)
            
        end
    end

end