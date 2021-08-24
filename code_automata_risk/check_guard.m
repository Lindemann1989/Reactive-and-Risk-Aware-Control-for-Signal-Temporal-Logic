function b = check_guard(c,Delta,p,C) % Input output composition acc. to ST2(ST1)
    
    b = 1;
    c_counter=1;
    for k=1:length(c)
        if strcmp(c{k},'none')
            % Do Nothing
        else
            if strcmp(Delta.g{k},'c0')
                % No guard
            elseif strcmp(Delta.g{k},'c1')
                if ~(p(c_counter)<C(c_counter))
                    b=0;
                    break
                end
            elseif strcmp(Delta.g{k},'c2')
                if ~(p(c_counter)==C(c_counter))
                    b=0;
                    break
                end
            elseif strcmp(Delta.g{k},'c3') % Case from system dynamics + Avoiding Zeno Behavior (together with c4)
                if ~(p(c_counter)>=C(c_counter))
                    b=0;
                    break
                end
            elseif strcmp(Delta.g{k},'c4') % Minimum time for uncontrollable + Avoiding Zeno Behavior (together with c3)
                if ~(p(c_counter)>=C(c_counter))
                    b=0;
                    break
                end
            else
                error('Should not happen');
            end
            c_counter = c_counter + 1;
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