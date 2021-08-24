%Checkes states
function b = operation1(lambda_s)
    
    b = 1;
    % Here it's gonna be hardcoding for now, exclude states that are
    % infeasible physically
    
    % First identify relevant propositions
    reg = zeros(6,1);
    for i=1:6
        ind=strfind(lambda_s,['p' num2str(i)]);
        ind_=strfind(lambda_s,['-p' num2str(i)]);
        for j=1:length(ind)
            if sum(ind{j})>=1 || sum(ind_{j})>=1
                reg(i) = j;
            end
        end
    end
    
    if reg(1)~=0 && reg(2)~=0 ...
            && strcmp(lambda_s{reg(1)},'p1') && strcmp(lambda_s{reg(2)},'p2') 
        % in two goal regions
        b = 0;
    elseif reg(1)~=0 && reg(3)~=0 ...
            && strcmp(lambda_s{reg(1)},'p1') && strcmp(lambda_s{reg(3)},'p3') 
        % in two goal regions
        b = 0;
    elseif reg(1)~=0 && reg(4)~=0 ...
            && strcmp(lambda_s{reg(1)},'p1') && strcmp(lambda_s{reg(4)},'p4') 
        % in two goal regions
        b = 0;
    elseif reg(1)~=0 && reg(6)~=0 ...
            && strcmp(lambda_s{reg(1)},'p1') && strcmp(lambda_s{reg(6)},'p6') 
        % in two goal regions
        b = 0;
    elseif reg(2)~=0 && reg(3)~=0 ...
            && strcmp(lambda_s{reg(2)},'p2') && strcmp(lambda_s{reg(3)},'p3') 
        % in two goal regions
        b = 0;
    elseif reg(2)~=0 && reg(4)~=0 ...
            && strcmp(lambda_s{reg(2)},'p2') && strcmp(lambda_s{reg(4)},'p4') 
        % in two goal regions
        b = 0;
    elseif reg(2)~=0 && reg(6)~=0 ...
            && strcmp(lambda_s{reg(2)},'p2') && strcmp(lambda_s{reg(6)},'p6') 
        % in two goal regions
        b = 0;
    elseif reg(3)~=0 && reg(4)~=0 ...
            && strcmp(lambda_s{reg(3)},'p3') && strcmp(lambda_s{reg(4)},'p4') 
        % in two goal regions
        b = 0;
    elseif reg(3)~=0 && reg(6)~=0 ...
            && strcmp(lambda_s{reg(3)},'p3') && strcmp(lambda_s{reg(6)},'p6') 
        % in two goal regions
        b = 0;
    elseif reg(4)~=0 && reg(6)~=0 ...
            && strcmp(lambda_s{reg(4)},'p4') && strcmp(lambda_s{reg(6)},'p6') 
        % in two goal regions
        b = 0;
    end

end

%     % Encoding of constraints for two input variables of ST2
%     d01 : p1 a p2
%     d02 : p1 o p2
%     d03 : -(p1 a p2)
%     d04 : -(p1 o p2)
%     d05 : p1
%     d06 : p2
%     d07 : -p1
%     d08 : -p2
%     d09 : p1 a -p2
%     d10: -p1 a p2
%     d11: p1 o -p2
%     d12: -p1 o p2
%     d13: True 