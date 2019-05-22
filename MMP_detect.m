%maindata     为需要判断事件的数据
%win_width    为滑动窗口的宽度
%level        为方差评判的一个阈值
%powState     为同时工作的三个工作状态


function [happen, start_end] = MMP_detect( maindata ,win_width, level, powState)
    %---------------利用窗口滑动，求取方差，利用方差来实现事件的判断---------------------
    %初始化window矩阵%定义一个窗口矩阵
    maindata = medfilt1(maindata,win_width);
    window = maindata([1:1:win_width]);
    varwindow = zeros(1,win_width);
    var_maindata = zeros(1,length(maindata));
    happen = zeros(1,length(maindata));
    time = 0;
    for i = 1:length(maindata) 
        if( (win_width-1+i) <= length(maindata)  )%没有到底的话
            
            window = maindata([i:1:win_width-1+i]);%更新窗口
            
        else 
            window =window; 
        end
        
        vartemp = var(window);%计算滑动窗口方差
        varwindow( mod(i,win_width)+1 ) = vartemp;%把滑动窗口的方差放入队列中  
        
        if( i > win_width )
            sigma =   (vartemp - mean(varwindow))/mean(varwindow);
            if( sigma > level)
               time  = time + 1;
               happen(i+win_width-1) = maindata(i+win_width-1);
            end
            var_maindata(i) = vartemp;
        end

    end

    %---------------------利用差分进行筛选----------------------------------
    
    %得到数据的差分形式，利用多步差分得到一个相对稳定的差分数据
    maindata_diff = 0.8 * diff_steps(maindata, 1) + 0.2 * diff_steps(maindata, 2); %+ 0.3 * diff_steps(maindata, 3);
    powerLevel = zeros(powState,1); %设置同时的上升沿个数最大为powState，即功率档位同时工作的个数
    checkRecord = zeros(powState,1); %记录上升沿的下标位置
    flag = 0;%上升沿记录标志，0为无，>0表示有上升沿
    check = find(happen ~= 0); %check 为happen数据中不为零的下标；
    start_end = zeros(length(check), 2); %创建开启关闭的对应表
    
    for i = 1 : length(check)
        index = check(i);
        if(maindata_diff(index) > 0) %差分大于零，判断为上升沿 
            p_index = find(powerLevel == 0, 1); 
            if(~isempty(p_index)) %判断还能不能有上升沿
                powerLevel(p_index) = maindata_diff(index);
                checkRecord(p_index) = index;
                flag = flag + 1;
            else
                happen(index) = 0;
            end
        elseif(maindata_diff(index) < 0) %判断为下降沿
            if(flag > 0)
                if(isturndown(index, maindata)) %判断后续状态是否为完全关闭状态，是的话，则消除所有上升沿
                    s_index = find(start_end(:,1)==0, 1);
                    p_index = find(powerLevel ~= 0);
                    start_end([s_index : s_index + length(p_index) - 1], :) = [checkRecord(p_index), index * ones(length(p_index),1)];
                    
                    powerLevel(p_index) = 0;
                    checkRecord(p_index) = 0;
                    flag = 0;
                else %匹配对应的下降沿
                    cmpLevel = powerLevel + maindata_diff(index) * ones(powState,1);
                    varLevel = var(maindata_diff(max(index-9, 1) : index));
                    cmpResult = (abs(cmpLevel) < 1.3 * varLevel ^ 0.5);
                    p_index = find(cmpResult == 1,1);
                    if(~isempty(p_index))
                        flag = flag - 1;
                        s_index = find(start_end(:,1)==0, 1);
                        start_end(s_index, :) = [checkRecord(p_index) index];
                        checkRecord(p_index) = 0;
                        powerLevel(p_index) = 0;
                    else
                        happen(index) = 0;
                    end
                end
            else
                happen(index) = 0;
            end
        else
            happen(index) = 0;
        end
    end
    
    %将没有消除的上升沿记录下来
    p_index = find(powerLevel ~= 0);
    if(~isempty(p_index))
        s_index = find(start_end(:,1)==0, 1);
        start_end([s_index : s_index + length(p_index) - 1], :) = [checkRecord(p_index), zeros(length(p_index),1)];
    end
    
    s_index = find(start_end(:,1)==0);
    start_end(s_index, :) = [];
%plot(maindata,'-b');
%hold on 
  plot(happen,'r');
end

function answer = isturndown(index, maindata)
    
len = length(maindata);
if(index == len)
    if(maindata(index)<2)
        answer = 1;
    else
        answer = 0;
    end
else 
    later_mean = mean(maindata(index + 1 : min(len, index + 10)));
    later_var = var(maindata(index + 1 : min(len, index + 10)));
    if(later_mean + later_var^0.5 < 3)
        answer = 1;
    else 
        answer = 0;
    end
end

end