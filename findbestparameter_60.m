clear all;
close all;
clc;


exceldata = xlsread('380_sort.xlsx');
%excel中数据的路径
rootpath = './data/';
channel_list = exceldata(:,6);
sub_list = exceldata(:,1);
video_list = exceldata(:,2);
onset_list = exceldata(:,7);

offset_list = exceldata(:,9);


vid2extend = 500;
%阈值设置
channel_ch = [1,1,1,1,1,1,1];

results = [];

% 初始化参数范围
window_len_range = 60; % 可根据实际需要调整范围
slide_len_range = 10:10:30;
th_ratio_range = 1:0.5:2;
serial_num_range = 2:1:5;
w_forward_range = 2:1:6;
w_back_range = 2:1:6;

for window_len = window_len_range
    for slide_len = slide_len_range
        for th_ratio = th_ratio_range
            for serial_num = serial_num_range
                for w_forward = w_forward_range
                    for w_back = w_back_range
                        matrix =zeros(380,4);
                        onset_temp = [];
                        offset_temp = [];
                        for i=1:length(sub_list)
                            % for i=370:380
                            onset_temp = [];
                            offset_temp = [];
                            disp(i)
                            subname = addLeadingZero(sub_list(i));
                            filepath = strcat(rootpath,subname,'_',num2str(video_list(i)),'.mat');
                            % 读取 CSV 文件
                            EMG_data = importdata(filepath);

                            % 将 table 转换为数组（如果需要）
                            EMG_data = table2array(EMG_data(200:end,1:8));
                            t_begin = onset_list(i);
                            t_end = offset_list(i);

                            if t_begin*1000<=vid2extend
                                clip_begin = 1;
                                d_on = t_begin*1000;
                            else
                                clip_begin= t_begin*1000-vid2extend;
                                d_on = vid2extend;
                            end

                            if t_end*1000+1000 >=length(EMG_data)
                                clip_end = length(EMG_data);
                                d_off = length(EMG_data)-t_end*1000;
                            else
                                clip_end= t_end*1000+vid2extend;
                                d_off =int16(t_end*1000 - clip_begin);

                            end


                            EMG_data_temp = EMG_data(clip_begin:clip_end,channel_list(i));


                            [emg_begin,emg_end] = emg_onset_offset_detection(EMG_data_temp,window_len,slide_len,th_ratio,serial_num,w_forward,w_back);

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
                            onset = min(onset_temp);
                            offset = max(offset_temp);
                            if isempty(onset)
                                onset =0;
                                offset=0;
                            end

                            matrix(i,:) = [d_on,d_off,onset,offset];


                        end
                        [n1, a1, proportion_above_0_5, mean_diff_1, se_1, rmse_1, mean_diff_2, se_2, rmse_2] = calculateIntervalOverlap(matrix);
                        results = [results; window_len, slide_len, th_ratio, serial_num, w_forward, w_back, n1, a1, proportion_above_0_5, mean_diff_1, se_1, rmse_1, mean_diff_2, se_2, rmse_2];
                    end

                end
            end
        end
    end
end

% 定义列名称
column_names = {'window_len', 'slide_len', 'th_ratio', 'serial_num', 'w_forward', 'w_back', 'n1', 'a1', 'proportion_above_0_5', 'mean_diff_1', 'se_1', 'rmse_1', 'mean_diff_2', 'se_2', 'rmse_2'};

% 将结果矩阵转换为表格
results_table = array2table(results, 'VariableNames', column_names);

% 导出结果到Excel文件
writetable(results_table, 'results_60.xlsx');

disp('Results saved to results.xlsx');






