function b = check_physical_transition(s1,s2)

b = 0;
global Parameter

for i=1:length(s1)
    if ~strcmp(s1(i),s2(i)) && i~=Parameter.ind
        b = 1;
        break
    end
end


end