function [b,list] = check_flow_into_guard(ST,i_ST,p,C) % Input output composition acc. to ST2(ST1)
    
global Parameter
list = [];
counter = 1;
b= 0;
for k=1:length(ST.Delta{i_ST}) % Check all transitions from i
    i_ST_next = find(strcmp(ST.Delta{i_ST}{k}.ss,ST.S));
    if check_guard(ST.c,ST.Delta{i_ST}{k},p,C) && ...
            check_reactive_transition(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) && ...
            check_feasible_transitions(ST.lambda_s{i_ST},ST.lambda_e{i_ST}{k},ST.lambda_s{i_ST_next}) 
        if ~sum(strcmp(ST.lambda_e{i_ST}{k}{Parameter.ind},list))
            list{counter} = ST.lambda_e{i_ST}{k}{Parameter.ind};
            counter = counter + 1;
            b= 1;
        end
    end
end
    

