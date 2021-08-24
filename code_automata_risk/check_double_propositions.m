function b = check_double_propositions(lambda_s)
    
    b = 1;
    
    if sum(strcmp(lambda_s,'p6')) && sum(strcmp(lambda_s,'-p6'))
        b=0;
    end
    
end