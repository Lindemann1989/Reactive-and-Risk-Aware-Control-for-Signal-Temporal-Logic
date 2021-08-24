% Function to check that the same resets are used for equal clocks when
% forming the product or input output composition

function b = compare_clock(c1,c2,R1,R2)

    b=1;
    
    for i=1:length(c1)
        for j=1:length(c2)
            if strcmp(c1{i},c2{j}) && ~strcmp(R1{i},R2{j})
                b=0;
            end
        end
    end


end