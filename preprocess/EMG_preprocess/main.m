clc;
clear all;
me_info = importdata('shaoyuan_new.mat');
nbME = size(me_info,1);
fs = 1000;
deltaT  = 0.2*1000;
metric = zeros(nbME,11);

for ii = 1:nbME
    disp(ii)
    %table 类型数据
%     sub = num2str(me_info(ii,1).VarName1);
%     metric(ii,1) = me_info(ii,1).VarName1;
%     seq = num2str(me_info(ii,2).VarName2);
%     metric(ii,2) = me_info(ii,2).VarName2;
%     channels = char(me_info(ii,3).VarName3);
%     channel = int16(str2double(channels(1)));
%     metric(ii,3) = channel;
%     onsetT = me_info(ii,4).VarName4 * fs + deltaT;
%     offsetT = me_info(ii,6).VarName6 * fs + deltaT;

%cell类型数据
    
    sub = ['sub', num2str(me_info{ii,1})];
    metric(ii,1) = me_info{ii,1};
    seq = num2str(me_info{ii,2});
    metric(ii,2) = me_info{ii,2};
    channels = me_info{ii,3};
    if  isnumeric(channels)
        channel = channels; 
    else     
        channels = char(channels);
        channel = int16(str2double(channels(1)));
    end
    metric(ii,3) = channel;
    onsetT = me_info{ii,4} * fs + deltaT;
    offsetT = me_info{ii,6} * fs + deltaT;
    
    ema_path = ['Z:\1A绍愿的期刊论文\1.肌电微表情实验\28-35\',sub,'\',seq,'.mat'];
    [out_emg,out_emg_norm] = emg_sigpro(ema_path,channel);
    close all;
    
    me_sig = out_emg(onsetT:offsetT);
    me_sig_norm = out_emg_norm(onsetT:offsetT);
    
    % max, mean??
    metric(ii,4) =  max(me_sig);
    %iEMG
    metric(ii,6) = jfemg('iemg' , me_sig_norm);
    
    
end