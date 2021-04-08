function [feature1, feature2] = get_features(data, header_data,leads_idx) %get_ECGLeads_features

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Extract features from ECG signals of every lead
% Inputs:
% 1. ECG data from available leads (data)
% 2. Header files including the number of leads (header_data)
% 3. The available leads index (in data/header file)
%
% Outputs:
% features for every ECG lead:
% 1. Age 2. Sex 3. root square mean (RSM) of the ECG leads
%
% Author: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 1.0
% Date 25-Nov-2020
% Version 2.1, 25-Jan-2021
% Version 2.2, 11-Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read number of leads, sample frequency and adc_gain from the header.
[recording,Total_time,num_leads,Fs,adc_gain,age,sex,Baseline] = extract_data_from_header(header_data);
num_leads = length(leads_idx);
if Total_time>60
        data=data(:,1:60*Fs);
end
jj=1;
try
    % ECG processing
    % Preprocessing
    LeadswGain=[];
    filt_ecg=[];
    res_ecg=[];
    ref_ecg=[];
    for i = [leads_idx{:}]
        % Apply adc_gain and remove baseline
        LeadswGain(i,:)   = (data(i,:)-Baseline(i))./adc_gain(i);
    end
    for i = [leads_idx{:}]
        filt_ecg(i,:)=BP_filter_ECG(LeadswGain(i,:),Fs);
    end
        if Fs<500
             for i = [leads_idx{:}]
               res_ecg(i,:)=resample(filt_ecg(i,:),500,Fs);
             end
             Fs=500;
             ref_ecg=ecg_noisecancellation( res_ecg, Fs);
        else
             ref_ecg=ecg_noisecancellation( filt_ecg, Fs);
        end
        
        % QRS and P wave detection
        
        lead2=ref_ecg(find([leads_idx{:}]==2),:);
        qrs=qrs_detect2(lead2,0.25, 0.6, Fs);
        if isempty(qrs)
            qrs=qrs_detect2(normalize(lead2),0.25, 0.6, Fs);
        end
        p_loc=[];
        p_loc=p_wave_detect(lead2,qrs,Fs);
        heart_rate=(length(qrs)*Fs/length(lead2))*60;%(bpm)
        fb_feat=feat_29_2021(lead2,qrs,Fs);
        tqwt_feat=tqwt_analysis(lead2,qrs,Fs);
        pr_feat=pr_stats2(lead2,qrs,p_loc,Fs); 
        % Extract root square mean (RSM) feature
        for i = [leads_idx{:}]
            RSM(i) = sqrt(sum(ref_ecg(i,:).^2))./length(ref_ecg(i,:));       
            st_feat(i,:)=st_p_stats2(ref_ecg(i,:),qrs,p_loc,Fs);
        end
        feature1=[fb_feat tqwt_feat heart_rate pr_feat];
        feature2=[st_feat RSM'];
    
catch
    feature1 = nan(1,71);
    feature2 = nan(num_leads,33);
end

% The last two features are age and sex from header file
features(num_leads+1) = age;
features(num_leads+2) = sex;
end
