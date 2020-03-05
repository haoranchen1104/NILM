%record_down 函数用于记录事件前后的相关信息

%输入：data原始数据，index数据脚标，num选取采样点的个数
%输出：down为一维向量，依次是
      %index下标，
      %index前num个数据的mu均值，
      %index后num个数据的mu均值，
      %sigma_before前num个数据的标准差
      %sigma_after后num个数据的标准差标准差，
      %diff_down下升沿的数据大小

function down = record_down(data, index, num)

limit = length(data);

low = max([index-num-3, 1]);
high = min([index+num, limit]);


mu_before = mean(data(low : index-1-3));
mu_after = mean(data(index + 1 : high));
sigma_before = var(data(low : index-1-3));
sigma_after = var(data(index + 1 : high));
diff_down = data(low) - data(high);%可尝试改变
down = [index, mu_before, mu_after, sigma_before, sigma_after, diff_down]; 

end