function  [onset,offset] = emg_onset_offset_detection(EMGdata,window_len,slide_len,th_ratio,serial_num,w_forward,w_back)
   % EMGdata: 输入的信号数据    
   % window_len：设定的滑动窗口的采样点个数   
   % slide_len：滑动窗口向前或者向后滑动的采样点个数 
   % th_ratio: 设置阈值的尺度
   % serial_num: 设置滑动窗口出现多少个连续的1，1表示滑动窗口的平均能量大于阈值
   % w_forward: 向前回退的窗口个数，以定位最好的开始帧时间
   % w_back: 向后回退的窗口个数，以定位最好的结束帧时间
  
   EMG_processed= process(EMGdata, 1000, 6, 2);
   % thresholds = 1.2;%选择幅值等超过阈值的信号

   frags = window_split(EMG_processed,window_len,slide_len);
   frame_energy = feature_calculation(frags);%计算每个分割后的窗口能量

   thresholds = th_ratio*mean(EMG_processed);%选择幅值等超过阈值的信号,可以自定义
   mark = zeros(length(frame_energy),1);
   for j=1:length(frame_energy)
       if frame_energy(j) >= thresholds
          mark(j) = 1; 
       end
   end
   p=2;
   onset_mark=zeros(1,length(mark));  %创建一个数组空间，保存开始帧
   offset_mark = zeros(1,length(mark)+1);  %创建一个数组空间，保存结束帧
   %计算每一个肌电信号超过阈值的第一个滑动窗口
   while p<length(mark) 
        m=1;
        while mark(p)==1  %计算出现波动的起始点窗口位置
            if p+m>length(mark) 
                break;      %此时已经到底了，退出，不再遍历
            end
            if mark(p+m)==1
                m = m + 1;
            else 
                break;
            end
        end
        if m>=serial_num  %判断连续出现的窗口时间上是否符合，m>3意味着这个信号波动的持续时间大于124ms
           onset_mark(p) = 1;
           offset_mark(p+m-1) = 1;
           p = p+m;
        else
           p = p+1; 
        end
    %     onset_mark(p) = 1; 
    %     p = p+1;
   end

%    disp(offset_mark)
   %计算确切的时间
   % onset = zeros(length(single_ch),1);%创建一个长度为原始数据长度的0值矩阵，保存起始帧的位置
   %找到开始帧的时间
   [~,On] = findpeaks(onset_mark);
   onset_temp = zeros(length(On),1);%创建一个长度为原始数据长度的0值矩阵，保存起始帧的位置
   for n=1:length(On)
       if On(n)-w_forward<1    %如果向前移动窗口超出了数组界限，就不再向前滑动窗口
          temp = frags(:,On(n));
          [~,index]= min(temp);
%           disp(On(n)-1)
          onset_temp(n) = (On(n)-1)*slide_len + index; %开始帧的确切点位位置
%           disp(onset_temp(n))
%           disp("**")
       else                    
          temp = frags(:,On(n)-w_forward);     %如果向前滑动窗口没有越界，就向前移动4个窗口
          [~,index]= min(temp);
          onset_temp(n) = (On(n)-w_forward-1)*slide_len + index; %开始帧的确切点位位置
%           disp(onset_temp(n))
       end
%        temp = frags(:,On(n)-w_forward);     %向前移动4个窗口
%        [~,index]= min(temp);

%        onset_temp(n) = (On(n)-w_forward-1)*slide_len + index; %开始帧的确切点位位置
   end
   %找到结束帧的时间
   [~,Off] = findpeaks(offset_mark);
   offset_temp = zeros(length(Off),1);%创建一个长度为原始数据长度的0值矩阵，保存起始帧的位置
%    disp(onset_temp)
%    disp(offset_temp)
   if length(On) ~= length(Off)
       disp("出现错误，on和off长度不一致")
       disp(["on长度：",num2str(length(On))])
%        onset_mark
       disp(["off长度：",num2str(length(Off))])
   end
   for n=1:length(Off)
       if Off(n)+w_back > length(offset_mark)-1  %如果向后移动发生了越界，那就不要移动了
          temp = frags(:,Off(n));     %向前移动两个窗口
          [~,index]= min(temp);
          offset_temp(n) = (Off(n)-1)*slide_len + index;
%           disp("----")
       else
          temp = frags(:,Off(n)+w_back);     %向前移动两个窗口
          [~,index]= min(temp);
          offset_temp(n) = (Off(n)+w_back-1)*slide_len + index; 
       end
%        offset_temp(n) = (Off(n)+w_back-1)*slide_len + index; 
   end
%   disp(onset_temp)
%    disp(offset_temp)
   onset = onset_temp;
   offset = offset_temp;
end