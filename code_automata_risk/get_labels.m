function labels = get_labels(RA,Stack1,Stack2)

    for i=1:length(Stack1)-1
        i_RA = find(strcmp(RA.S,Stack1{i+1})==1);
        labels{i} = RA.lambda_s{i_RA};
    end
    
    for i=1:length(Stack2)-1
        i_RA = find(strcmp(RA.S,Stack2{i+1})==1);
        labels{length(Stack1)-1+i} = RA.lambda_s{i_RA};
    end

end