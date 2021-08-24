function b = check_equal(W,W_new) 
b = 1;
for i=1:length(W)
    if ~strcmp(W{i},W_new{i})
        b=0; 
        break
    end
end

end