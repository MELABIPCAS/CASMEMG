function  output = process( EMGRAW, fs, LOWPASSRATE,NUMPASSES )
    %%this function is created to process the emg data,the output should be the
    %linear enveloped data 
    %the input data should be raw emg data,samping rate,lowpass rate and the
    %number of passes.

    % 读取数据
%     t = 0:1/fs:length(EMGRAW)*1/fs-1/fs; %这一步是根据采样频率计算要画出x轴的点的个数，也就是时间单位为秒
    %画出原始EMG数据
%     figure();
%     subplot(5,1,1);
%     plot(t,EMGRAW);      %plot raw EMG data
%     xlabel('Time (s)');
%     title('Raw EMG Data');
    


    %滤波 filter the noise
    Wn1 = 20/(fs/2); %the band of cutoff frequency
    Wn2 = 450/(fs/2); %the band of cutoff frequency
    [b,a]= butter(NUMPASSES,[Wn1,Wn2],'bandpass'); % 20-450 的带通滤波参数
    EMGFILT = filtfilt(b,a,EMGRAW); %带通滤波（去相位差后）
%     subplot(5,1,2);
%     plot(t,EMGFILT);
%     xlabel('Time (s)');
%     title('EMG Signal with Noise Removed');

%     data2_ICA = EMGFILT'; 
%     data_syn= ICA(data2_ICA); 
%     data_t = data_syn';

%     %ICA分解 ICA data.
    % data2_ICA = EMGFILT'; 
    % data_syn = ICA(data2_ICA); 
    % data_t = data_syn';

    data_t = EMGFILT'; 
% %     t = 0:1/fs:length(data_t)*1/fs-1/fs;
%     subplot(6,1,3);
%     plot(t,data_t);
%     xlabel('Time(s)');
% %     legend("1","2","3","4");
%     title('ICA data');
    
    %去除直流电 remove DC offset.
     EMGDC = data_t - mean(data_t); %均值应该为0
%     subplot(5,1,3);
%     plot(t,EMGDC);
%     xlabel('Time (s)');
%     title('EMG with DC Offset Removed');


    %全波整流 full-wave rectification
     EMGFWR = abs(EMGDC); %全波整流，把正弦波的负值部分翻上去。
%     subplot(5,1,4);
%     plot(t,EMGFWR);
%     xlabel('Time (s)');
%     title('EMG with Full-Wave Rectification');
% 
    %线性包络 Linear Envelope
    Wn = LOWPASSRATE/(fs/2);
    [b,a] = butter(NUMPASSES,Wn,'low');
    EMGLE = filtfilt(b,a,EMGFWR);% 低通滤波
%     subplot(5,1,5);
%     plot(t,EMGLE);
%     xlabel('Time (s)');
%     title('Linear Envelope of EMG');

    output = EMGLE; % 输出结果
end