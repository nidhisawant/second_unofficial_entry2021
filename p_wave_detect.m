function [p_locs] = p_wave_detect(signal,y,fs)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
heart_rate=(length(y)*fs/length(signal))*60;%(bpm)
    for i=2:length(y)
        try
        x1=signal(y(i)-floor((240*10^-3)*fs*(72/heart_rate)):y(i)-floor((120*10^-3)*fs*(72/heart_rate)));
        [pks,locs] = findpeaks(x1);%250samples:50ms
        [mm,idx]=max(pks);

            if (length(idx)>=2)
                locs1(i-1)=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+locs(idx(end));
            else
                locs1(i-1)=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+locs(idx);
            end
        catch
             x1=signal(y(i)-floor((300*10^-3)*fs*(72/heart_rate)):y(i)-floor((120*10^-3)*fs*(72/heart_rate)));
        [pks,locs] = findpeaks(x1);%250samples:50ms
        [mm,idx]=max(pks);

            if (length(idx)>=2)
                locs1(i-1)=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+locs(idx(end));
            else
                locs1(i-1)=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+10;
            end
        end

        
    end
    p_locs=locs1;

end

