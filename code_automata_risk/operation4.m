% Checks viability of whole transitions 
function b = operation4(lambda_s,lambda_ss)
    
    b = 1;
    % Since we assume RRT^* + TCBF, we can do any more transitions between
    % states 
    % First identify relevant propositions
    regs = zeros(6,1);
    regss = zeros(6,1);
    for i=1:6
        ind=strfind(lambda_s,['p' num2str(i)]);
        ind_=strfind(lambda_s,['-p' num2str(i)]);
        for j=1:length(ind) 
            if sum(ind{j})>=1 || sum(ind_{j})>=1
                regs(i) = j;
            end
        end
        ind=strfind(lambda_ss,['p' num2str(i)]);
        ind_=strfind(lambda_ss,['-p' num2str(i)]);
        for j=1:length(ind)
            if sum(ind{j})>=1 || sum(ind_{j})>=1
                regss(i) = j;
            end
        end
    end
    
    
    if regs(2)~=0 && regs(6)~=0 && regss(2)~=0 && regss(6)~=0 && ...
            strcmp(lambda_s{regs(2)},'p2') && strcmp(lambda_s{regs(6)},'-p6') && ...
            strcmp(lambda_ss{regss(2)},'-p2') && strcmp(lambda_ss{regss(6)},'p6')
        % left
        b = 0;
    elseif regs(2)~=0 && regs(6)~=0 && regss(2)~=0 && regss(6)~=0 && ...
            strcmp(lambda_s{regs(2)},'-p2') && strcmp(lambda_s{regs(6)},'p6') && ...
            strcmp(lambda_ss{regss(2)},'p2') && strcmp(lambda_ss{regss(6)},'-p6')
        % left
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