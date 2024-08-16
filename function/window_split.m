function  results = window_split( EMGRAW, frame_length, frame_slide )
    len = length(EMGRAW);

    for i=1:frame_slide:len-frame_length
        frag = EMGRAW(i:i+frame_length);
        if i==1
           frags = frag; 
        else
           frags = [frags;frag]; 
        end
%         RMS(i)=sqrt(mean((EMGRAW(i*frame_length:(i+1)*frame_length).^2)));
    end

    results = frags';

end