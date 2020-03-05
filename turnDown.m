function where_died = turnDown(list_down)
len = length(list_down);
where = zeros(len,1);
for i = 1 : len
    if(list_down(i,3) + list_down(i,5) < 150 + 70)
        where(i) = i;
    end
end

where(where == 0) = [];

where_died = list_down(where, 1);
end