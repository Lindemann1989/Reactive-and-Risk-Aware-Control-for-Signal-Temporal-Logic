function [t_,p,p0] = find_successor(p,C)
    

    
    % Find successor point 
    counter = 2;
 
    bb = find(p(:,counter-1)<=C.'); % Find all relevant clocks that don't exceed the maximum clock constant
    ind = find(p(:,counter-1)-fix(p(:,counter-1))~=0); % Find all clocks that are not on singleton locations
    inter = intersect(bb,ind);
    if isempty(inter) % When the region consists only of singletons or clocks exeeding maximum clock constant, push it manually
        t=0.5; 
    elseif length(inter)~=length(bb) % At least one singleton 
        t=min(ceil(p(inter,counter-1))-p(inter,counter-1));
        t=t/2;
    else % All open intervals
        t=min(ceil(p(inter,counter-1))-p(inter,counter-1));
    end
    p(:,counter) = p(:,counter-1);
    for k=1:length(bb)
        p(bb(k),counter)=min(p(bb(k),counter-1)+t,C(bb(k)).'+0.5); 
        t_ = t;
    end

    p0=p(:,1);
    p=p(:,2);
end

% Each clock has 4 states (diagonal):
% 0:    0
% 0.5:  (0,1)
% 1:    1
% 1.5:  (1,2)
% 2:    2

% Relation of clocks (upper diagonal):
% 0: no meaning, indicates this is not needed for this clock pair
% 1: row "greater" than column
% 2: row "equal" to column
% 3: row "smaller" than column