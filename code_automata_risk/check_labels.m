function logi = check_labels(in,out)
    logi = 1;
    counter = 1;
    for i=1:length(out)
        % Check the Transducers ST2 with one input first
        if strfind(out{i},'p')==1
            if strfind(in{counter},'q')==1
                counter = counter + 1;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'p')==2
            if strfind(in{counter},'q')==2
                counter = counter + 1;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'true')==1
            counter = counter + 1;
        end
        % Check the Transducers ST2 with two inputs now
        if strfind(out{i},'d01')
            if strfind(in{counter},'q')==1 && strfind(in{counter+1},'q')==1
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d02')
            if strfind(in{counter},'q')==1 || strfind(in{counter+1},'q')==1
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d03')
            if strfind(in{counter},'q')==2 || strfind(in{counter+1},'q')==2
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d04')
            if strfind(in{counter},'q')==2 && strfind(in{counter+1},'q')==2
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d05')
            if strfind(in{counter},'q')==1 
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d06')
            if strfind(in{counter+1},'q')==1
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d07')
            if strfind(in{counter},'q')==2 
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d08')
            if strfind(in{counter+1},'q')==2
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d09')
            if strfind(in{counter},'q')==1 && strfind(in{counter+1},'q')==2
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d10')
            if strfind(in{counter},'q')==2 && strfind(in{counter+1},'q')==1
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d11')
            if strfind(in{counter},'q')==1 || strfind(in{counter+1},'q')==2
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d12')
            if strfind(in{counter},'q')==2 || strfind(in{counter+1},'q')==1
                counter = counter + 2;
            else
                logi = 0; % Not satisfied, state should not be considered
                break
            end
        elseif strfind(out{i},'d13s')
            % Just true for eventually or Always_inf (one label)
            counter = counter + 1;
        elseif strfind(out{i},'d13')
            % Just true for until (two labels)
            counter = counter + 2;
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