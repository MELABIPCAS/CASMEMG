% 读取Excel数据
exceldata = xlsread('380_sort.xlsx');
% Excel中数据的路径
rootpath = 'Y:/鲁绍愿/鲁绍愿实验数据/肌电视频数据采集/';
channel_list = exceldata(:,6);
sub_list = exceldata(:,1);
video_list = exceldata(:,2);

% 创建data文件夹（如果不存在）
if ~exist('data', 'dir')
    mkdir('data');
end

% 打开文件以写入路径
fid = fopen('emg_onset_tr1.txt', 'w'); % 写入文件路径
fid2 = fopen('emg_offset_tr1.txt', 'w'); % 写入文件路径

% 初始化
onset_temp = [];
offset_temp = [];

% 阈值设置
channel_ch = [1,1,1,1,1,1,1];

for i = 1:length(sub_list)
    onset_temp = [];
    offset_temp = [];
    disp(i)
    
    % 生成带有前导零的被试名
    subname = addLeadingZero(sub_list(i));
    filepath = strcat(rootpath, subname, '/', num2str(video_list(i)), '.mat');
    
    % 检查文件是否存在
    if exist(filepath, 'file')
        % 复制文件到当前代码路径下的data文件夹中
        destpath = fullfile('data', [subname, '_', num2str(video_list(i)), '.mat']);
        copyfile(filepath, destpath);
        
        % 将文件路径写入到emg_onset_tr1.txt和emg_offset_tr1.txt中
        fprintf(fid, '%s\n', destpath);
        fprintf(fid2, '%s\n', destpath);
    else
        warning('File %s does not exist.', filepath);
    end
end

% 关闭文件
fclose(fid);
fclose(fid2);

