function logi = check_feasible_transitions(lambda_s,lambda_e,lambda_ss)

global Parameter
    
    for i=1:length(lambda_s)
        if check_implication(lambda_s{i},lambda_e{i}) || check_implication(lambda_ss{i},lambda_e{i}) || i==Parameter.ind
            logi = 1;
        else
            logi = 0;
            break;
        end
    end
end