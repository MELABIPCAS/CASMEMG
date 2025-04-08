function [out_emg,out_emg_norm] = emg_sigpro(ema_path,channel)
data = importdata(ema_path);
data = data (200:end,:);
%%
orders = table2array(data(:,9));
idx = find(orders==-1);
data(idx,:)=[];
%%
fs=1000;
L = size(data,1);
emg = table2array(data(:,1:8));
orders = table2array(data(:,9));
time = table2array(data(:,10));
sig = table2array(data(:,11));
emg1 = emg(:,channel);

%%
LOWPASSRATE = 6;
NUMPASSES = 2;
out_emg = processemg(emg1,fs,LOWPASSRATE,NUMPASSES);
out_emg_norm = (out_emg-min(out_emg))/(max(out_emg)- min(out_emg));

end
