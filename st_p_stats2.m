function[feat]=st_p_stats2(signal,y,p_locs,fs)

%note make it as varying input

heart_rate=(length(y)*fs/length(signal))*60;%(bpm)

try

    for i=2:length(y)-1

        try

            x=signal(y(i)+(120*10^-3)*fs:y(i)+(180*10^-3)*fs);%x:st segments

            

        catch

            x=(signal(y(i):length(signal)));

            

        end

        try

          

            %z=signal(y(i)-100:y(i)-40);%y: p-wave

             %x1=signal(y(i)-floor((240*10^-3)*fs*(72/heart_rate)):y(i)-floor((120*10^-3)*fs*(72/heart_rate)));

            %[pks,locs] = findpeaks(x1);%250samples:50ms

            %[mm,idx]=max(pks);

            %if (length(idx)>=2)

                %locs1=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+p_locs(i-1);

            %else

                %locs1=y(i)-floor((240*10^-3)*fs*(72/heart_rate))+locs(idx);

            %end

            z=signal(p_locs(i-1)-floor((70*10^-3)*fs):p_locs(i-1)+floor((70*10^-3)*fs));

        catch

           

            z=signal(1:y(i)-floor((80*10^-3)*fs));

        end

        

        

        feat11(i-1,:)=ststats2(x,fs);

        feat22(i-1,:)=ststats2(z,fs);

 

    end

    

   feat=[nanmean(feat11,1) nanmean(feat22,1) ];%mean(feat22,1)

 

catch

    feat=NaN.*ones(1,32);

end

    

 

end

 

% for i=1:length(y)

%     x(i,:)=signal(y(i):y(i)+80);%x:st segments

% end

%     for i=1:14

%         plot(z{i})

%         pause(1)

%     end

function[feat]=ststats2(x,fs)

 

   

      try  

    st_median = median(x);

    st_kurto = kurtosis(x);

    st_skew = skewness(x);

    st_mean = mean(x);

    st_mode = mode(x);

    st_max=max(x);

    st_min=min(x);

    st_var=var(x);

    energy=sum(x.^2);

    e1=wentropy(x,'norm',4);

    e2=wentropy(x,'sure',0.06);

    e3=wentropy(x,'norm',3);

    

    ffac=(std(diff(diff(x))).*std(x))./std(diff(x)).^2;

    

    %bandpower(x,1000,[50 150])

    f1=obw(x,fs);

    f2=meanfreq(x,fs);

    f3=medfreq(x,fs);

 

    feat=[ f1 f2 f3 ffac e1 e2 e3 energy st_var st_median, st_kurto, st_skew, st_mean, st_mode,st_max, st_min ];

      catch

          feat=NaN.*ones(1,16);

      end

    %[1 2 4 5 6 7 9] useful for normal

 

end