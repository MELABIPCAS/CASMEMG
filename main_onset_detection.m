clear all;
close all;
clc;


exceldata = xlsread('380_sort.xlsx');
%excel中数据的路径
rootpath = '/Volumes/Melab_Share/鲁绍愿/鲁绍愿实验数据/肌电视频数据采集/';
channel_list = exceldata(:,6);
sub_list = exceldata(:,1);
video_list = exceldata(:,2);
fid=fopen(['emg_onset_tr1.txt'],'w');%写入文件路径
fid2=fopen(['emg_offset_tr1.txt'],'w');%写入文件路径
onset_temp = [];
offset_temp = [];
%阈值设置
channel_ch = [1,1,1,1,1,1,1];
for i=1:length(sub_list)
% for i=370:380
    onset_temp = [];
    offset_temp = [];
    disp(i)
    subname = addLeadingZero(sub_list(i));
    filepath = strcat(rootpath,subname,'/',num2str(video_list(i)),'.mat');
    % 读取 CSV 文件
    EMG_data = importdata(filepath);

    % 将 table 转换为数组（如果需要）
    EMG_data = table2array(EMG_data(:,1:8));

    EMG_data_temp = EMG_data(200:length(EMG_data),channel_list(i));
    [emg_begin,emg_end] = emg_onset_offset_detection(EMG_data_temp,64,20,2,3,4,4);

%     EMG_processed= process(EMG_data_temp, 1000, 6, 2);
%     figure
%     plot(EMG_processed)
%     xlabel('sample')
%     ylabel('Value')
%     hold on
%     line([emg_begin emg_begin],[0 0.1],'linestyle','-','Color','red');
%     line([emg_end emg_end],[0 0.1],'linestyle','-','Color','magenta');
% 
% 
%     emg_begin = emg_begin + 150;
%     emg_begin = emg_begin./1000;
%     emg_end = emg_end + 150;
%     emg_end = emg_end./1000;
% %保存开始帧
%     fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%     for j=1:length(emg_begin)
% %         fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%         fprintf(fid,'%.3f\t',emg_begin(j));   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%     end
%     fprintf(fid,'\n');
%     %保存结束帧
%     fprintf(fid2,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%     for p=1:length(emg_end)
% %         fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%         fprintf(fid2,'%.3f\t',emg_end(p));   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
%     end
%     fprintf(fid2,'\n');
%     emg_begin = [];
%     emg_end = [];
    





    %更具iEMG值判断是否符合
    p_len = length(emg_begin);

    if p_len ~= 0

        for j=1:length(emg_begin)

            emg_process = process(EMG_data_temp, 1000, 6, 2);
            tempData = emg_process(emg_begin(j):emg_end(j));

            emg_iemg = sum(tempData);

            if emg_iemg >=channel_ch(channel_list(i))
               t1 = emg_begin(j);
               t2 = emg_end(j);
               onset_temp = [onset_temp,t1];
               offset_temp = [offset_temp,t2];
            end             
        end
    end
    
    onset_temp = onset_temp + 200;
    onset_temp = onset_temp./1000;
    offset_temp = offset_temp + 200;
    offset_temp = offset_temp./1000;



    %保存开始帧
    fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
    for j=1:length(onset_temp)
%         fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
        fprintf(fid,'%.3f\t',onset_temp(j));   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
    end
    fprintf(fid,'\n');
    %保存结束帧
    fprintf(fid2,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
    for p=1:length(offset_temp)
%         fprintf(fid,'%d\t',i);   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
        fprintf(fid2,'%.3f\t',offset_temp(p));   %按列输出，若要按行输出：fprintf(fid,'%.4\t',A(jj)); 
    end
    fprintf(fid2,'\n');
 

end

fclose(fid);
fclose(fid2);






