function logi = check_input_labels(in,out)
    logi = 1;
    for i=1:length(out)
        % Check the Transducers ST2 with one input first
        if ~strcmp(in{i},out{i})
            logi = 0; % Not satisfied, state should not be considered
            break
        end
        
        
        if strfind(out{i},'none')
            error('This should not happen');
        elseif strfind(in{i},'none')
            error('This should not happen');
        end
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