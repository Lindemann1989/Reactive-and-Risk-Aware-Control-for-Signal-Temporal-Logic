function W = game(RA)
    
    W = RA.S;
    N = length(RA.S);
    a1 = 0;
    
    
    % Find common accepting states
    b=[];
    F_share=[];
    for i=1:length(RA.F{1})
        ind = 1;
        if length(RA.F)==1 % unlikely to happen, nonetheless
            F_share = RA.F;
            break
        else
            for j=2:length(RA.F)
                if ~sum(strcmp(RA.F{1}{i},RA.F{j}))
                    break
                end
                if j==length(RA.F)
                    b = [b i];
                end
            end
        end
    end
    
    if length(RA.F)>1
        F_share = RA.F{1}(b);
    end
    
    while (1-a1) % line 2
        H = []; % line 3
        a2 = 0;
        W_int_ = [];
        W_int = pi_(RA,W); % For compt. reasons this happens here and not in the inner loop
        counter = 1;
        for i=1:length(W_int) % line 5 intersection operation
            if sum(strcmp(W_int{i},F_share)) || sum(strcmp(W_int{i},'r0'))
                W_int_{counter} =  W_int{i};
                counter = counter + 1;
            end
        end
        while (1-a2) % line 4
            H_new =[];
            H_int = [];
            H_int = pi_(RA,H);
            counter = 1;
            for i=0:N-1 % line 5 - union operation
                if sum(strcmp(H_int,['r' num2str(i)]))
                    H_new{counter} = H_int{find(strcmp(H_int,['r' num2str(i)])==1)};
                    counter = counter + 1;
                elseif sum(strcmp(W_int_,['r' num2str(i)]))
                    H_new{counter} = W_int_{find(strcmp(W_int_,['r' num2str(i)])==1)};
                    counter = counter + 1;
                end
            end
            if length(H)~=length(H_new) %saves comp. time
                a2 = 0;
            else
                a2 = check_equal(H,H_new);
            end
            H = H_new;
        end
        W_new = H_new;
        if length(W)~=length(W_new) %saves comp. time
            a1 = 0;
        else
            a1 = check_equal(W,W_new);
        end
        W = W_new;
    end


end