
function[feat]=pr_stats2(signal,y,p_locs,fs)

%note make it as varying input

heart_rate=(length(y)*fs/length(signal))*60;%(bpm)

    try

        

        kk=1;pr1=[];%pr=[];

       for i=2:length(y)-1

        

%         x=signal(y(i)-floor((240*10^-3)*fs*(72/heart_rate)):y(i)-floor((120*10^-3)*fs*(72/heart_rate)));
% 
%        [pks,locs] = findpeaks(x);%250samples:50ms
% 
%         [mm,idx]=max(pks);
% 
%        if (length(idx)>=2)
% 
%         locs1=locs(idx(end));
% 
%        else
% 
%            locs1=locs(idx);
% 
%        end
% 
%     

            pr1(kk)=y(i)-p_locs(i-1);%(p_locs(i-1)+y(i)-floor((240*10^-3)*fs*(72/heart_rate)));
           
           % pr=rmoutliers(pr1,'percentile',[20 100]);

            kk=kk+1;

       end

    

    feat=ststats2(pr1,fs);

    catch

        feat=zeros(1,8);

    end

% to plot qrs locs

    

   %pr=rmoutliers(PR_interval,'percentile',[20 100]);

 

    if isnan(feat)

feat=[0 0 0 0 0 0 0 0];

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

 

   

        

    st_median = median(x)/fs;

    st_kurto = kurtosis(x)/fs;

    st_skew = skewness(x)/fs;

    st_mean = mean(x)/fs;

    st_mode = mode(x)/fs;

    st_max=max(x)/fs;

    st_min=min(x)/fs;

    st_var=var(x)/fs;

    

 

 

 

    feat=[ st_var st_median, st_kurto, st_skew, st_mean, st_mode,st_max, st_min ];

    

    %put provision for nan

    %featurepr(:,[ 1 2 3 4  6 8 ]) for class 2

 

end