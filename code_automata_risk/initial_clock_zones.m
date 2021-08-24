function RA = initial_clock_zones(ST,RA,Nc,counter,i) % Input output composition acc. to ST2(ST1)
    RA.reg{counter} = zeros(Nc,Nc);
    global Parameter
    c_counter = 1;
    for k=1:length(ST.c)
        if strcmp(ST.c{k},'none')
            % Do Nothing
        else
            % Set Diagonals
            if strcmp(ST.Delta{1}{i}.R{k},'r0')
                RA.reg{counter}(c_counter,c_counter) = RA.p{1}(c_counter) + 0.5; % in both cases, we will end up in an open region 
            elseif strcmp(ST.Delta{1}{i}.R{k},'r1')
                RA.reg{counter}(c_counter,c_counter) = RA.p{1}(c_counter) + 0.5; % in both cases, we will end up in an open region 
            else
                error('This should not happen');
            end 
            c_counter = c_counter + 1;
        end
    end
    
    % Set Off-Diagonals
    for k=1:Nc   
        for l=k+1:Nc 
            RA.reg{counter}(k,l)=2; 
%             if RA.reg{counter}(k,k)==RA.reg{counter}(l,l)
%                 RA.reg{counter}(k,l)=2; 
%             elseif RA.reg{counter}(k,k)<RA.reg{counter}(l,l)
%                 RA.reg{counter}(k,l)=3;
%             elseif RA.reg{counter}(k,k)>RA.reg{counter}(l,l) 
%                 RA.reg{counter}(k,l)=1;
%             end                    
        end
    end
    
    

end
    


% Each clock has 4 states (diagonal):
% 0:    0
% 0.5:  (0,1)
% 1:    1
% 1.5:  (1,2)
% 2:    2
% ...

% Relation of clocks (upper diagonal):
% 0: no meaning, indicates this is not needed for this clock pair
% 1: row "greater" than column
% 2: row "equal" to column
% 3: row "smaller" than column