function [sr_next,p_next] = calc_reset(c,Delta,p,Nc) % Input output composition acc. to ST2(ST1)
    global Parameter
    c_counter = 1;
    for k=1:length(c)
        if strcmp(c{k},'none')
            % Do nothing
        else
            % Reset next p
            if strcmp(Delta.R{k},'r0')
                p_next(c_counter)=p(c_counter)+Parameter.add_time_reset; % add_time_reset always pushes into an open region
            elseif strcmp(Delta.R{k},'r1')
                p_next(c_counter)=0+Parameter.add_time_reset;
            end

            % Form next clock region - Set diagonals
            if p_next(c_counter)-fix(p_next(c_counter))==0 % Should actually never happen
                sr_next(c_counter,c_counter) = p_next(c_counter);
                error('should not happen)')
            else
                sr_ind(c_counter) = p_next(c_counter)-fix(p_next(c_counter));
                sr_next(c_counter,c_counter) = fix(p_next(c_counter))+0.5;
            end
            
            c_counter = c_counter + 1;
        end
    end
    
    % Set Off-Diagonals
    for k=1:Nc   
        for l=k+1:Nc 
            if  sr_next(k,k)-fix(sr_next(k,k))==0 || ...
                    sr_next(l,l)-fix(sr_next(l,l))==0 
                sr_next(k,l) = 0;
                error('should not happen)')
            elseif abs(sr_ind(k)-sr_ind(l))<Parameter.add_time_reset
                sr_next(k,l)=2; 
            elseif sr_ind(k)>sr_ind(l)
                sr_next(k,l)=1; 

            elseif sr_ind(k)<sr_ind(l)
                sr_next(k,l)=3; 
            end                    
        end
    end

    p_next = p_next.';
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