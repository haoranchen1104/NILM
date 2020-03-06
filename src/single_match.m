function married = single_match(girl, boys)

len = size(boys,1);
married = [];

for i = 1 : len
    
    couple_diff = girl(6) + boys(i, 6);
    if(abs(couple_diff) < 0.6 * (girl(4)+boys(i,5)) )
        married = i;
        break;
    elseif(abs(girl(2)- boys(i,3)) < 0.3 * girl(2) )
        married = i;
        break;
    end

end

end