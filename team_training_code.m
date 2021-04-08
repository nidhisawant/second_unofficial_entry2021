function  model = team_training_code(input_directory,output_directory) % train_ECG_leads_classifier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Train ECG leads and obtain classifier models
% for 12-lead, 6-leads, 3-leads and 2-leads ECG sets
% Inputs:
% 1. input_directory
% 2. output_directory
%
% Outputs:
% model: trained model
% 4 logistic regression models for 4 different sets of leads
%
% Author: Erick Andres Perez Alday, PhD, <perezald@ohsu.edu>
% Version 1.0 Aug-2020
% Revision History
% By: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 2.0 1-Dec-2020
% Version 2.2 25-Jan-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading data...')

% Find files.
input_files = {};
features =[];
for f = dir(input_directory)'
    if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
        input_files{end + 1} = f.name;
    end
end

% Extract classes from dataset.
% read number of unique classes
classes = get_classes(input_directory,input_files);
num_classes = length(classes);     % number of classes
num_files   = length(input_files);
Total_data  = cell(1,num_files);
Total_header= cell(1,num_files);

%% Load data recordings and header files
% Iterate over files.
disp('Training model..')

label=zeros(num_files,num_classes);

for i = 1:num_files
    disp(['    ', num2str(i), '/', num2str(num_files), '...'])
    % Load data.
    file_tmp = strsplit(input_files{i},'.');
    tmp_input_file = fullfile(input_directory, file_tmp{1});
    [data,header_data] = load_challenge_data(tmp_input_file);
    %% Check the number of available ECG leads
    tmp_hea = strsplit(header_data{1},' ');
    num_leads = str2num(tmp_hea{2});
    [leads, leads_idx] = get_leads(header_data,num_leads);

    %% Extract features
    [tmp_features1, tmp_features2]  = get_features(data,header_data,leads_idx);
    features(i,:) = tmp_features1(:);
    features_cell{i}= tmp_features2;
    %% Extract labels
    for j = 1 : length(header_data)
        if startsWith(header_data{j},'#Dx')
            tmp = strsplit(header_data{j},': ');
            % Extract more than one label if avialable
            tmp_c = strsplit(tmp{2},',');
            for k=1:length(tmp_c)
                idx=find(strcmp(classes,tmp_c{k}));
                label(i,idx)=1;
            end
            break
        end
    end


end

%% Getting labels for 27 classes
for j=1:size(classes,2)
    classes_double(j)=str2double(classes{j});
end
scored_labels=[270492004	164889003	164890007	426627000	713427006	713426002	445118002	39732003	164909002	251146004	698252002	10370003	284470004	427172004	164947007	111975006	164917005	47665007	59118001	427393009	426177001	426783006	427084000	63593006	164934002	59931005	17338001];
for j=1:size(scored_labels,2)
    scored_label_idx(j)=find(classes_double==scored_labels(j));
end
new_label=[];
for j=1:size(scored_labels,2)
    vec=label(:,scored_label_idx(j));
    new_label=[new_label vec];
end
%% train 4 logistic regression models for 4 different sets of leads

% Train 12-lead ECG model
disp('Training 12-lead ECG model...')
num_leads = 12;
[leads, leads_idx] = get_leads(header_data,num_leads);
% Features = [1:12] features from 12 ECG leads + Age + Sex
%Features_leads_idx = [leads_idx{:},13,14];
features2 = cellfun(@(x)reshape(x([leads_idx{:}],:),1,[]),features_cell,'UniformOutput',false);
feat=[];
for k=1:length(features2) 
    feat(k,:)=features2{k};
end
Features_leads = [features feat];
%model = mnrfit(Features_leads,label,'model','hierarchical');
model=model_code(Features_leads,new_label);
save_ECG12leads_model(model,output_directory,classes);

% Train 6-lead ECG model
disp('Training 6-lead ECG model...')
num_leads = 6;
[leads, leads_idx] = get_leads(header_data,num_leads);
% Features = [1:6] features from 6 ECG leads + Age + Sex
features2 = cellfun(@(x)reshape(x([leads_idx{:}],:),1,[]),features_cell,'UniformOutput',false);
feat=[];
for k=1:length(features2) 
    feat(k,:)=features2{k};
end
Features_leads = [features feat];
%model = mnrfit(Features_leads,label,'model','hierarchical');
model=model_code(Features_leads,new_label);
save_ECG6leads_model(model,output_directory,classes);

% Train 3-lead ECG model
disp('Training 3-lead ECG model...')
num_leads = 3;
[leads, leads_idx] = get_leads(header_data,num_leads);
% Features = [1:3] features from 3 ECG leads + Age + Sex
features2 = cellfun(@(x)reshape(x([leads_idx{:}],:),1,[]),features_cell,'UniformOutput',false);
feat=[];
for k=1:length(features2) 
    feat(k,:)=features2{k};
end
Features_leads = [features feat];
%model = mnrfit(Features_leads,label,'model','hierarchical');
model=model_code(Features_leads,new_label);
save_ECG3leads_model(model,output_directory,classes);

% Train 2-lead ECG model
disp('Training 2-lead ECG model...')
num_leads = 2;
[leads, leads_idx] = get_leads(header_data,num_leads);
% Features = [1:2] features from 2 ECG leads + Age + Sex
features2 = cellfun(@(x)reshape(x([leads_idx{:}],:),1,[]),features_cell,'UniformOutput',false);
feat=[];
for k=1:length(features2) 
    feat(k,:)=features2{k};
end
Features_leads = [features feat];
%model = mnrfit(Features_leads,label,'model','hierarchical');
model=model_code(Features_leads,new_label);
save_ECG2leads_model(model,output_directory,classes);

end

function save_ECG12leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'twelve_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECG6leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'six_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECG3leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'three_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECG2leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'two_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECGleads_features(features,output_directory) %save_ECG_model
% Save results.
tmp_file = 'features.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'features');
end

% find unique number of classes
function classes = get_classes(input_directory,files)

classes={};
num_files = length(files);
k=1;
for i = 1:num_files
    g = strrep(files{i},'.mat','.hea');
    input_file = fullfile(input_directory, g);
    fid=fopen(input_file);
    tline = fgetl(fid);
    tlines = cell(0,1);

    while ischar(tline)
        tlines{end+1,1} = tline;
        tline = fgetl(fid);
        if startsWith(tline,'#Dx')
            tmp = strsplit(tline,': ');
            tmp_c = strsplit(tmp{2},',');
            for j=1:length(tmp_c)
                idx2 = find(strcmp(classes,tmp_c{j}));
                if isempty(idx2)
                    classes{k}=tmp_c{j};
                    k=k+1;
                end
            end
            break
        end
    end

    fclose(fid);

end
classes=sort(classes);
end

function [data,tlines] = load_challenge_data(filename)

% Opening header file
fid=fopen([filename '.hea']);

if (fid<=0)
    disp(['error in opening file ' filename]);
end

tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);

f=load([filename '.mat']);

try
    data = f.val;
catch ex
    rethrow(ex);
end

end
