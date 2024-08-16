function  results = feature_calculation( Data )
    [m,n] = size(Data);
%     disp(n)
    for k=1:n
%         RMS(k)=sqrt(mean((Data(:,k).^2)));
        RMS(k)=mean(Data(:,k));
    end
    results = RMS;

end