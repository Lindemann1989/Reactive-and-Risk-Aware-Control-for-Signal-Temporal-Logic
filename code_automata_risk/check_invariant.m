function b = check_invariant(c,iota1,iota2,p0,p_next,C) % Input output composition acc. to ST2(ST1)
    
    b = 1;
    c_counter = 1;
    for k=1:length(c)
        if strcmp(c{k},'none')
            % Do Nothing
        else
            % Current State
            if strcmp(iota1{k},'c0')
                % No invariant
            elseif strcmp(iota1{k},'c1')
                if ~(p0(c_counter)<C(c_counter))
                    b=0;
                    break
                end
            elseif strcmp(iota1{k},'c2')
                if ~(p0(c_counter)==C(c_counter))
                    b=0;
                    break
                end
            end

            % Next State
            if strcmp(iota2{k},'c0')
                % No invariant
            elseif strcmp(iota2{k},'c1')
                if ~(p_next(c_counter)<C(c_counter))
                    b=0;
                    break
                end
            elseif strcmp(iota2{k},'c2')
                if ~(p_next(c_counter)==C(c_counter))
                    b=0;
                    break
                end
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