fid=fopen('emg_onset.txt');       %首先打开文本文件coordinate.txt
temp = []
i=0;
while ~feof(fid)    % while循环表示文件指针没到达末尾，则继续
    % 每次读取一行, str是字符串格式
    str = fgetl(fid);     
    i=i+1;
    disp(i)
    disp(str)
    % 以 ',' 作为分割数据的字符,结果为cell数组
%     s=regexp(str,' ','split');    
    
    %取数组中第一个元素s{1}，先转换成字符串char再转换成数字str2num
%     temps1 = str2num(char(s{1}));  
%     temps2 = str2num(char(s{2}));
%     temp = [temp;temps1 temps2];  
end
fclose(fid);
