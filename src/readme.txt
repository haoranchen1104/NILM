author 陈浩然


checkRecord.m ——该函数的作用是根据事件起始可疑点表和事件结束可疑点表进行匹配，将事件的起始和截止的时间点输出
输入   list_up    为一维向量，依次是
      index下标，
      index前num个数据的mu均值，
      index后num个数据的mu均值，
      sigma_before前num个数据的标准差
      sigma_after后num个数据的标准差标准差，
      diff_up上升沿的数据大小
      
      list_down   为一维向量，依次是
      index下标，
      index前num个数据的mu均值，
      index后num个数据的mu均值，
      sigma_before前num个数据的标准差
      sigma_after后num个数据的标准差标准差，
      diff_down下升沿的数据大小
      
      powState    为用电器最多的级数状态

输出   list        为匹配的事件表，第一列为事件的起始端，第二列为事件的结束端  





diff_steps.m ——根据输入的步数，得到几级差分
输入   origin      为原始的功率数据,
      steps       为差分的步数

输出   result      为原始功率数据后的差分结果





eventExtract.m ——该函数用于提取每个事件的功率
输入   power       为原始功率数据

      start_end   为事件的起始和终止点

      list_up     为一维向量，依次是
      index下标，
      index前num个数据的mu均值，
      index后num个数据的mu均值，
      sigma_before前num个数据的标准差
      sigma_after后num个数据的标准差标准差，
      diff_up上升沿的数据大小
      
      list_down   为一维向量，依次是
      index下标，
      index前num个数据的mu均值，
      index后num个数据的mu均值，
      sigma_before前num个数据的标准差
      sigma_after后num个数据的标准差标准差，
      diff_down下升沿的数据大小

输出   events      为每个隔离出来的事件功率值





findPrB.m ——该函数的作用是根据输入的统计值得到最符合该概率分布的前五用电器排名
输入  Smean        为稳态值（统计平均）
     range        是值的波动范围
     data         为字符串，表示当前在哪个数据中查询

输出  name         获得用电器的分类名称
     Pr           为测试数据在分布中的概率
     confidence   为该方法判断的区间自信程度





MMP_detect.m ——该函数将总表的数据检测事件的发生与截止，并生成单个事件的时间段和功率值
输入  maindata     为需要判断事件的数据
     win_width    为滑动窗口的宽度
     level        为方差评判的一个阈值
     powState     为同时工作的三个工作状态

输出  start_end    为事件的起始和终止点
     events       为每个隔离出来的事件功率值





record_down.m ——函数用于记录事件前后的相关信息
输入  data         为原始数据，
     index        为数据脚标，
     num          为选取采样点的个数

输出  down为一维向量，依次是
     index下标，
     index前num个数据的mu均值，
     index后num个数据的mu均值，
     sigma_before前num个数据的标准差
     sigma_after后num个数据的标准差标准差，
     diff_down下升沿的数据大小





record_up.m ——函数用于记录事件前后的相关信息
输入  data         为原始数据，
     index        为数据脚标，
     num          为选取采样点的个数

输出  up           为一维向量，依次是
     index下标，
     index前num个数据的mu均值，
     index后num个数据的mu均值，
     sigma_before前num个数据的标准差
     sigma_after后num个数据的标准差标准差，
     diff_down下升沿的数据大小





single_match.m ——该函数用于匹配事件的上升下降，一个上升对应一个下降
输入  girl         为需要匹配的上升沿数据
     Boys         为可能的下降沿数据

输出  married      为匹配成功的数据下标





TwoOne_match.m ——该函数用于事件的二对一的上升下降匹配
输入  powerLevel   为可能功率级数表,
     girl         为当前需要匹配的事件起始可疑点,
     list_down    为事件结束可疑点表,
     index_begin  为事件结束可疑点的开始下标,
     index_end    为事件结束可疑点的结束下标

输出  left_one     为匹配成功的之前事件起始可疑点,
     new_one      为匹配成功的当前事件起始可疑点,
     index_married为匹配成功的数据下标





turnDown.m ——该函数根据原始数据，确定出数据中的全关状态点
输入  list_down    为事件结束可疑点表

输出  where_died   为全部用电器关闭的状态点