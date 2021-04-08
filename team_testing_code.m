%% Apply classifier model to test set

function [score, label,classes] = team_testing_code(data,header_data, loaded_model)

model   = loaded_model.model;
classes = loaded_model.classes;

num_classes = length(classes);

label = zeros([1,num_classes]);

score = ones([1,num_classes]);

% Extract features from test data
tmp_hea = strsplit(header_data{1},' ');
num_leads = str2num(tmp_hea{2});
[leads, leads_idx] = get_leads(header_data,num_leads);
[features1, features2] = get_features(data,header_data,leads_idx);
feat=reshape(features2([leads_idx{:}],:),1,[]);
features = [features1 feat];
% Use your classifier here to obtain a label and score for each class.
score = model_test_code(model,features,classes);
[~,idx] = find(score>0.5);

label(idx)=1;
end
