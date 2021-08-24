function [p] = pick_point_from_region(RA,Nc,i,C)
    
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