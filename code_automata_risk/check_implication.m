function logi = check_implication(arg1,arg2) %arg1->arg2?
    logi = 1;
    
    if ~strcmp(arg1,arg2)
        logi=0;
    end
    
end

%     % Encoding of constraints for two input variables of ST2
%     d01 : p1 a p2
%     d02 : p1 o p2
%     d03 : -(p1 a p2) = -p1 o -p2
%     d04 : -(p1 o p2) = -p1 a -p2
%     d05 : p1
%     d06 : p2
%     d07 : -p1
%     d08 : -p2
%     d09 : p1 a -p2
%     d10: -p1 a p2
%     d11: p1 o -p2
%     d12: -p1 o p2
%     d13: True 