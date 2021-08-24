% Excludes transitions that are physical and reactive at the same time
function b = check_reactive_transition(s1,s2,s3)

b = 1;
global Parameter

if strcmp(s2(Parameter.ind),'p5') && check_physical_transition(s1,s3)
    b = 0;
end


end