function ST = intersection(ST,T_min) 

    
    Nc = 0; %number of real clocks
    for i=1:length(ST.c)
        if ~strcmp(ST.c{i},'none')
            Nc = Nc + 1;
        end
    end
    
    ST.b=horzcat(ST.b,num2str(T_min));
    ST.c=horzcat(ST.c,['c' num2str(Nc+1)]);
    ST.iota{1}=horzcat(ST.iota{1},'none');
    for j=1:length(ST.Delta{1})
        ST.Delta{1}{j}.g=horzcat(ST.Delta{1}{j}.g,'c0');
        ST.Delta{1}{j}.R=horzcat(ST.Delta{1}{j}.R,'r1');
    end
    for i=1:length(ST.S)-1
        ST.iota{i+1}=horzcat(ST.iota{i+1},'c0');
        for j=1:length(ST.Delta{i+1})
            i_ST_next = find(strcmp(ST.Delta{i+1}{j}.ss,ST.S));
            if check_physical_transition(ST.lambda_s{i+1},ST.lambda_s{i_ST_next}) % Only reset this clock when a real physical transition has happened
                ST.Delta{i+1}{j}.g=horzcat(ST.Delta{i+1}{j}.g,'c3');
                ST.Delta{i+1}{j}.R=horzcat(ST.Delta{i+1}{j}.R,'r1');
            else
                ST.Delta{i+1}{j}.g=horzcat(ST.Delta{i+1}{j}.g,'c3');
                ST.Delta{i+1}{j}.R=horzcat(ST.Delta{i+1}{j}.R,'r1');
            end
        end
    end



end

