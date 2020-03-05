%maindata     为需要判断事件的数据
%win_width    为滑动窗口的宽度
%level        为方差评判的一个阈值
%powState     为同时工作的三个工作状态


function [start_end, events] = MMP_detect( maindata ,win_width, level, powState)
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
    
    diff_data = diff(maindata);
    for i = 1:length( diff_data  )
        if( abs(diff_data(i)) < 20  )
            diff_data(i) = 0;
        end
    end
    %%%
    for i = 1:length(diff_data)
       if( (diff_data(i)~= 0) )
           j = i;
            while( diff_data(j)~= 0 )
                j = j+1;
            end
       end
       
            if( happen(j) == 0 )
                happen(j) = maindata(j);
            end  
    end
    
    for i = 1:1:length(happen)-1
        if( happen(i)~=0 )
            if( happen(i+1)~= 0)
                happen(i)= 0;
            end
        end
    end
    
    %清除小于一定值的事件判断
    for i = 1:1:length(happen)
        if( happen(i) ~= 0 )
            down = max(1, i-3);
            up = min(i+3, length(happen));
            if( abs(maindata(up) - maindata(down) )< 10 )
                happen(i) =0;
            end
        end
    end

    %---------------------利用差分进行筛选-----------------------------------------
    
    %得到数据的差分形式，利用多步差分得到一个相对稳定的差分数据
    maindata_diff = 0.5 * diff_steps(maindata, 1) + 0.2 * diff_steps(maindata, 2) + 0.3 * diff_steps(maindata, 3);
%     powerLevel = zeros(powState,1); %设置同时的上升沿个数最大为powState，即功率档位同时工作的个数
%     checkRecord = zeros(powState,1); %记录上升沿的下标位置
%     flag = 0;%上升沿记录标志，0为无，>0表示有上升沿
    check = find(happen ~= 0); %check 为happen数据中不为零的下标；
    list_up = zeros(length(check), 6);
    list_down = zeros(length(check), 6);
    
    
    for i = 1 : length(check)
        index = check(i);
        if(maindata_diff(index) > 0) %差分大于零，判断为上升沿
            list_up(i,:) = record_up(maindata, index, 5);
        elseif(maindata_diff(index) < 0) %判断为下降沿
            list_down(i,:) = record_down(maindata, index, 5);
        else
            happen(index) = 0;
        end
    end
    
    list_up(list_up(:,1) == 0,:) = [];
    list_down(list_down(:,1) == 0,:) = [];
    
    start_end = checkRecord(list_up, list_down, powState);
    events = eventExtract(maindata, start_end, list_up, list_down);
end

