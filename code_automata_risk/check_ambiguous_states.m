function [b,state] = check_ambiguous_states(RA,new_state,sr_next) % Input output composition acc. to ST2(ST1)
    
    b=1;
    state=0;
    for i=1:length(RA.S)
        if isequal(RA.reg{i},sr_next) && strcmp(RA.state{i},new_state)
            b = 0; 
            state = i;
            break
        end
    end

end