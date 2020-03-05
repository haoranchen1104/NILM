%checkRecord 函数用于匹配合适的事件

%输入：list_up为一维向量，依次是
      %index下标，
      %index前num个数据的mu均值，
      %index后num个数据的mu均值，
      %sigma_before前num个数据的标准差
      %sigma_after后num个数据的标准差标准差，
      %diff_up上升沿的数据大小
      
      %list_down为一维向量，依次是
      %index下标，
      %index前num个数据的mu均值，
      %index后num个数据的mu均值，
      %sigma_before前num个数据的标准差
      %sigma_after后num个数据的标准差标准差，
      %diff_down下升沿的数据大小
      
      %powState为用电器最多的级数状态

%输出：list 为匹配的事件表，第一列为事件的起始端，第二列为事件的结束端      
      
function list = checkRecord(list_up, list_down, powState)
%去除尖刺
spur_up = isspur(list_up);
spur_down = isspur(list_down);

list_up(spur_up==1,:) = [];
list_down(spur_down==1,:) = [];
%获取表单长度
len_up = length(list_up);
% len_down = length(list_down);

list = zeros(len_up, 2);
where_died = turnDown(list_down);

powerLevel = zeros(powState,6); %设置同时的上升沿个数最大为powState，即功率档位同时工作的个数

for i = 1 : len_up
    index = list_up(i,1);        
    die = find(where_died > index, 1);
    if(~isempty(die))
        die = where_died(die);
    else
        die = max(list_down(:,1));
    end
    powerLevel = powerLevel_update(powerLevel, index, where_died);
        
    begin_index = find(list_down(:,1) > index,1);
    died_index = find(list_down(:,1) == die, 1);
    possible_down = list_down(begin_index:died_index, :);
    
    married = single_match(list_up(i,:), possible_down);
    
    if(~isempty(married))
        index_married = possible_down(married, 1);
        if(index_married - index < 100000)
            arrange_index = find(list(:,1)==0, 1);
            list(arrange_index,:) = [index, index_married];

%             remove_index = find(list_down(:,1) == index_married, 1);
%             list_down(remove_index, :) = [];
        end
    else
        p_indexes = find(powerLevel(:,1) == 0);
        if(length(p_indexes) == powState)
            p_index = find(powerLevel(:,1) == 0, 1);
            if(~isempty(p_index)) %判断还能不能有上升沿
                powerLevel(p_index, :) = list_up(i,:);
            end
        else
            [left_one, new_one, index_married] = TwoOne_match(powerLevel, list_up(i,:), list_down, begin_index, died_index);
            if(~isempty(left_one))
                arrange_index = find(list(:,1)==0, 1);
                list(arrange_index,:) = [left_one, index_married];
                arrange_index = find(list(:,1)==0, 1);
                list(arrange_index,:) = [new_one, index_married];
                
%                 remove_index = find(list_down(:,1) == index_married, 1);
%                 list_down(remove_index, :) = [];
            else
                p_index = find(powerLevel == 0, 1);
                if(~isempty(p_index)) %判断还能不能有上升沿
                    powerLevel(p_index, :) = list_up(i,:);
                end
            end
        end
    end
    
    
end

check = find(powerLevel(:,1) ~= 0);

if(~isempty(check))
    len = length(check);

    for i = 1 : len
        ch_index = check(i);
        die = find(where_died > powerLevel(ch_index, 1), 1);
        if(~isempty(die))
            die = where_died(die);
        else
            die = max(list_down(:,1));
        end
        died_index = find(list_down(:,1) == die, 1);

        if(died_index - powerLevel(ch_index,1) < 100000)
            arrange_index = find(list(:,1)==0, 1);
            list(arrange_index,:) = [powerLevel(ch_index,1), died_index];
        end
    end

end

list(list(:,1)==0,:) = [];

end

%powLevel_update 用来更新状态，当
function new_powL = powerLevel_update(old_powL, index, where_died)

check = find(old_powL(:,1) ~= 0);

if(~isempty(check))
    len = length(check);

    for i = 1 : len
        ch_index = check(i);
        die = find(where_died > old_powL(ch_index, 1), 1);
        died_index = where_died(die);
        if(index >= died_index)
            old_powL(ch_index,:) = zeros(1,6);
        elseif(old_powL(ch_index, 1) < index - 10000)
            old_powL(ch_index,:) = zeros(1,6);
        end
    end

end

new_powL = old_powL;

end




function answer = isspur(list)

len = length(list);
answer = zeros(len, 1);

for i = 1 : len
    mu_diff = list(i, 2) - list(i, 3);
    if(abs(mu_diff) < 0.1 * (list(i,2) + list(i,3)))
        answer(i) = 1;
    else
        answer(i) = 0;
    end
end

end