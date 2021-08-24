function [sr,p,p0] = find_successors(RA,Nc,i,C)
    
    % Pick point from current clock region
    for k=1:Nc
        if RA.reg{i}(k,k)-fix(RA.reg{i}(k,k))==0 %singleton
            p(k) = RA.reg{i}(k,k);
        else %fractional part, open interval
            % Compare properly with other clocks
            if k==1
                p(k) = 0.5 + fix(RA.reg{i}(k,k)); % (0,1) + fix(RA.reg{i}(k,k))
            else
%                 a = 1;
%                 b = 0;
                a = 0;
                b = 1;
                for l=1:k-1
                    if RA.reg{i}(l,l)-fix(RA.reg{i}(l,l))==0
                        % Means that RA.reg{i}(l,l) does not indicate an open interval, so skip this
                    elseif RA.reg{i}(l,k)==1
                        %b = max(b,p(l)-fix(RA.reg{i}(l,l))); % min here?
                        b = min(b,p(l)-fix(RA.reg{i}(l,l)));
                    elseif RA.reg{i}(l,k)==2
                        p(k) = p(l)-fix(RA.reg{i}(l,l)) + fix(RA.reg{i}(k,k)); % fract(p(l)) + fix(RA.reg{i}(k,k))
                        break %Tap out here
                    elseif RA.reg{i}(l,k)==3
                        %a = min(a,p(l)-fix(RA.reg{i}(l,l))); % max here?
                        a = max(a,p(l)-fix(RA.reg{i}(l,l)));
                    end
                    if l==k-1
                        if a==1 && b==0
                            p(k) = 0.5 + fix(RA.reg{i}(k,k)); %No constraints imposed so far
                        else
%                             if a==1
%                                 a=0+eps;
%                             else
%                                 a=a+eps;
%                             end
%                             if b==0
%                                 b=1-eps;
%                             else
%                                 b=b-eps;
%                             end
                            p(k) = (b-a).*0.5 + a + fix(RA.reg{i}(k,k));
                        end
                    end
                end
            end
        end
    end
    
    % Find successor points and successor clock regions
    p = p.';
    counter = 2;
    while counter~=0
        bb = find(p(:,counter-1)<=C.'); % Find all relevant clocks that don't exceed the maximum clock constant
        ind = find(p(:,counter-1)-fix(p(:,counter-1))~=0); % Find all clocks that are not on singleton locations
        inter = intersect(bb,ind);
        if isempty(inter) % When the region consists only of singletons or clocks exeeding maximum clock constant, push it manually
            t=0.5; 
        elseif length(inter)~=length(bb) % At least one singleton 
            t=min(ceil(p(inter,counter-1))-p(inter,counter-1));
            t=t/2;
        else % All open intervals
            t=min(ceil(p(inter,counter-1))-p(inter,counter-1));
        end
        p(:,counter) = p(:,counter-1);
        for k=1:length(bb)
            p(bb(k),counter)=min(p(bb(k),counter-1)+t,C(bb(k)).'+0.5); 
        end
        
        % Form successor region, first set diagonals
        for k=1:Nc
            if p(k,counter)-fix(p(k,counter))==0
                sr{counter-1}(k,k) = p(k,counter);
            else
                sr_ind(k) = p(k,counter)-fix(p(k,counter)); % Used later to determine off-diagonals
                sr{counter-1}(k,k) = fix(p(k,counter))+0.5;
            end
        end
        
        % Now set off-diagonals
        for k=1:Nc   
            for l=k+1:Nc 
                if  sr{counter-1}(k,k)-fix(sr{counter-1}(k,k))==0 || ...
                    sr{counter-1}(l,l)-fix(sr{counter-1}(l,l))==0 
                    sr{counter-1}(k,l) = 0;
                elseif sr_ind(k)>sr_ind(l)
                    sr{counter-1}(k,l) = 1;
                elseif sr_ind(k)==sr_ind(l)
                    sr{counter-1}(k,l) = 2;
                elseif sr_ind(k)<sr_ind(l)
                    sr{counter-1}(k,l) = 3;
                else
                    error('This should not happen');
                end                    
            end
        end
        
        if isempty(bb) % When p is greater than all clock constants
            counter=-1;
        end
        
        counter = counter + 1;
    end
    p0=p(:,1);
    p=p(:,2:end);
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