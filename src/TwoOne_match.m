function [left_one, new_one, index_married] = TwoOne_match(powerLevel, girl, list_down, index_begin, index_end)

left_girls = powerLevel(powerLevel(:,1) ~= 0,:);
num_girls = size(left_girls,1);
girls_like = girl(6)*ones(num_girls, 1) + left_girls(:,6);

boys = list_down(index_begin:index_end,:);
len = size(boys,1);

for i = 1 : len
    couple_diff = girls_like + boys(i, 6)*ones(num_girls, 1);
    absolute_diff = abs(couple_diff);
    match = find(absolute_diff < 0.15 * (girl(4)+boys(i,5)), 1);
    if(~isempty(match))
        index_married = boys(i,1);
        left_one = left_girls(match,1);
        new_one = girl(1);
        return;
    end
end
left_one = [];
new_one = [];
index_married = [];

end