function W_new = pi_(RA,W)
global Parameter
% BLOCKING STATES ARE MARKED AS SUCH
counter = 1;
W_new{counter} = [];
for i=1:length(RA.S)
    if RA.zeno{i}==1 %skip checking all s since they can't occur (zeno avoidance)
        for j=1:length(RA.Delta{i})
            if ~strcmp(RA.Delta{i}{j},'blocking') && sum(strcmp(RA.Delta{i}{j}.ss,W)) && sum(strcmp(RA.lambda_e{i}{j}{Parameter.ind},'-p5'))
                W_new{counter} = RA.S{i};
                counter = counter + 1;
                break
            end
        end
    else % here, uncontrollable events can occur
        s = {'p5','-p5'};
        for j=1:length(RA.Delta{i})
            if ~strcmp(RA.Delta{i}{j},'blocking') && sum(strcmp(RA.Delta{i}{j}.ss,W)) && ... 
                    sum(strcmp(RA.lambda_e{i}{j}{Parameter.ind},s)) 
                s(strcmp(RA.lambda_e{i}{j}{Parameter.ind},s))=[];
            end
            if isempty(s)
                W_new{counter} = RA.S{i};
                counter = counter + 1;
                break
            end
        end
    end
end

end