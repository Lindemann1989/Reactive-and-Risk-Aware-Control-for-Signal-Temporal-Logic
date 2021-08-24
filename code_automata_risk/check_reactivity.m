function [b,z] = check_reactivity(ST,i_ST,p0,C,b_time,b_trans,list) % Input output composition acc. to ST2(ST1)

    % This is done manually for now
    s = {'p5','-p5'}; % All possibilities
    b = 0;
    z = 0;
    global Parameter
    c_counter=1;
    c_counter1=1;
    for k=1:length(ST.c)
        if strcmp(ST.c{k},'none')
            % Do Nothing
        else
            if strcmp(ST.c{k},'c11') % Avoiding Zeno Behavior
                break
            end
            c_counter = c_counter + 1;
        end
        c_counter1 = c_counter1 + 1;
    end

    if p0(c_counter)<=str2num(ST.b{c_counter1}) %This works under the assumption that the zeno constanst is the smallest one, then time transition is possible and uncontrollable propositions can be neglected
        b=1;
        z=1;
    else
        % Check first all transitions within region
        for k=1:length(ST.Delta{i_ST}) 
            if check_guard(ST.c,ST.Delta{i_ST}{k},p0,C) && sum(strcmp(ST.lambda_e{i_ST}{k}{Parameter.ind},s)) 
                s(strcmp(ST.lambda_e{i_ST}{k}{Parameter.ind},s))=[];
            end
            if isempty(s)
                b=1;
                break
            end
        end
        % Now check if we can flow or jump into successor region
        indd = 1;
        if b_time && b_trans
            if ~strcmp(list,'-p5') 
                list{length(list)+1} = '-p5';
            end
        elseif b_time %means b_trans is false
            list = [];
            list{1} = '-p5';
        elseif b_trans
            % do nothing
        elseif ~(b_time || b_trans)
            indd = 0;
        end
%         if length(s)==1 && sum(strcmp(s,'-p5'))==1 && b_time  %time transition possible when no uncontrollable event occurs
%             b=1;
%         end
        if indd
            for i=1:length(list)
                if sum(strcmp(s,list{i}))
                    s(strcmp(s,list{i}))=[];
                end
            end
        end
        if isempty(s)
            b=1;
        end
    end
    
    a=1;
    
%     if length(varargin)==1 %Indicates initial transition
%         for k=1:length(ST.Delta{i_ST})
%             if sum(strcmp(ST.lambda_e{i_ST}{k}{4},s)) && strcmp(ST.gamma_e{i_ST}{k},'q')
%                 s(strcmp(ST.lambda_e{i_ST}{k}{4},s))=[];
%             end
%             if isempty(s)
%                 b=1;
%                 break
%             end
%         end
%         if ~isempty(s) && length(s)==1 && sum(strcmp(s,'-p5'))==1  %time transition is always possible initially and if only -p5
%             b=1;
%         end
%     elseif p0(2)<=str2num(ST.b{c_counter1}) %This works under the assumption that the zeno constanst is the smallest one, then time transition is possible and uncontrollable propositions can be neglected
%         b=1;
%         z=1;
%     else
%         for k=1:length(ST.Delta{i_ST}) 
%             if check_guard(ST.c,ST.Delta{i_ST}{k},p0,C,T{i_ST}{k}) && sum(strcmp(ST.lambda_e{i_ST}{k}{4},s)) 
%                 s(strcmp(ST.lambda_e{i_ST}{k}{4},s))=[];
%             end
%             if isempty(s)
%                 b=1;
%                 break
%             end
%         end
%         if ~isempty(s) && length(s)==1 && sum(strcmp(s,'-p5'))==1 && b_time %time transition possible when no uncontrollable event occurs
%             b=1;
%         end
%     end
    
    
end