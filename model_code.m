function [model] = model_code(compl_feat,lab_t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

model={};

s_idx = find(sum(lab_t,2)==1);
normaldata = compl_feat(s_idx,:);
labels = lab_t(s_idx,:);
normalgroups = labels(:,22);

% normal vs others

t = ClassificationTree.template('minleaf',1);
%model
normal_model = fitensemble(normaldata,normalgroups,'Bag',496,t,'type','classification');
%pred=predict(ClassTreeEns,tsdata);
 model{1}=normal_model;
% other data

idx_other = find(normalgroups==0);
otherdata=normaldata(idx_other,:);
othergroups = labels(idx_other,:);


 b1=[2 3 4 13 14 15 16 24 27];% AF Flutter Bradycardia PAC PVC PRO-PR PRO-QT 
% rythm vs others

rythmdata=otherdata;
rythmgroups=sum(othergroups(:,b1),2);
t = ClassificationTree.template('minleaf',1);
%model
rythm_model = fitensemble(rythmdata,rythmgroups,'Bag',90,t,'type','classification');
model{2}=rythm_model;

% AF vs others
af_idx=find(rythmgroups==1);
rytreelabels=othergroups(af_idx,:);
afdata=otherdata(af_idx,:);
afgroups=rytreelabels(:,2);
t = ClassificationTree.template('minleaf',1);
%model
af_model = fitensemble(afdata,afgroups,'Bag',90,t,'type','classification');
model{3}=af_model;


% Flutter vs others
flutterdata=afdata;
fluttergroups=rytreelabels(:,3);
t = ClassificationTree.template('minleaf',1);
%model
flutter_model = fitensemble(flutterdata,fluttergroups,'RusBoost',90,t,'type','classification');
model{4}=flutter_model;

% Bradycardia vs others
bradydata=afdata;
bradygroups=rytreelabels(:,4);
t = ClassificationTree.template('minleaf',1);
%model
brady_model = fitensemble(bradydata,bradygroups,'Bag',90,t,'type','classification');
model{5}=brady_model;

% PAC vs others
pacdata=afdata;
pacgroups=sum(rytreelabels(:,[13 24]),2);
t = ClassificationTree.template('minleaf',1);
%model
pac_model = fitensemble(pacdata,pacgroups,'Bag',90,t,'type','classification');
model{6}=pac_model;

% PVC vs others
pvcdata=afdata;
pvcgroups=sum(rytreelabels(:,[14 27]),2);
t = ClassificationTree.template('minleaf',1);
%model
pvc_model = fitensemble(pvcdata,pvcgroups,'RusBoost',90,t,'type','classification');
model{7}=pvc_model;

% pro-QT vs others
pqtdata=afdata;
pqtgroups=rytreelabels(:,16);
t = ClassificationTree.template('minleaf',1);
%model
pqt_model = fitensemble(pqtdata,pqtgroups,'Bag',90,t,'type','classification');
model{8}=pqt_model;

%% other branch

nonry_idx=find(rythmgroups==0);
othtreelabels=othergroups(nonry_idx,:);
nrthdata=otherdata(nonry_idx,:);

% 1st degree vs others
idbdata=nrthdata;
idbgroups=othtreelabels(:,1);
t = ClassificationTree.template('minleaf',1);
%model
idb_model = fitensemble(idbdata,idbgroups,'RusBoost',90,t,'type','classification');
model{9}=idb_model;

% CRBBB vs others
crbbbdata=nrthdata;
crbbbgroups=sum(othtreelabels(:,[5 19]),2);
t = ClassificationTree.template('minleaf',1);
%model
crbbb_model = fitensemble(crbbbdata,crbbbgroups,'RusBoost',90,t,'type','classification');
model{10}=crbbb_model;

% IRBBB vs others
irbbbdata=nrthdata;
irbbbgroups=othtreelabels(:,6);
t = ClassificationTree.template('minleaf',1);
%model
irbbb_model = fitensemble(irbbbdata,irbbbgroups,'RusBoost',90,t,'type','classification');
model{11}=irbbb_model;

% LAFB vs others
lafbdata=nrthdata;
lafbgroups=othtreelabels(:,7);
t = ClassificationTree.template('minleaf',1);
%model
lafb_model = fitensemble(lafbdata,lafbgroups,'RusBoost',90,t,'type','classification');
model{12}=lafb_model;

% LAD vs others
laddata=nrthdata;
ladgroups=othtreelabels(:,8);
t = ClassificationTree.template('minleaf',1);
%model
lad_model = fitensemble(laddata,ladgroups,'RusBoost',90,t,'type','classification');
model{13}=lad_model;

% LBBB vs others
lbbbdata=nrthdata;
lbbbgroups=othtreelabels(:,9);
t = ClassificationTree.template('minleaf',1);
%model
lbbb_model = fitensemble(lbbbdata,lbbbgroups,'RusBoost',90,t,'type','classification');
model{14}=lbbb_model;

% LQRS vs others
lqrsdata=nrthdata;
lqrsgroups=othtreelabels(:,10);
t = ClassificationTree.template('minleaf',1);
%model
lqrs_model = fitensemble(lqrsdata,lqrsgroups,'RusBoost',90,t,'type','classification');
model{15}=lqrs_model;

% NSIVCD vs others
nsivcddata=nrthdata;
nsivcdgroups=othtreelabels(:,11);
t = ClassificationTree.template('minleaf',1);
%model
nsivcd_model = fitensemble(nsivcddata,nsivcdgroups,'RusBoost',90,t,'type','classification');
model{16}=nsivcd_model;

% Pacing rythm vs others
prdata=nrthdata;
prgroups=othtreelabels(:,12);
t = ClassificationTree.template('minleaf',1);
%model
pr_model = fitensemble(prdata,prgroups,'RusBoost',90,t,'type','classification');
model{17}=pr_model;

% q wave abnormal vs others
qabdata=nrthdata;
qabgroups=othtreelabels(:,17);
t = ClassificationTree.template('minleaf',1);
%model
qab_model = fitensemble(qabdata,qabgroups,'RusBoost',90,t,'type','classification');
model{18}=qab_model;

% RAD vs others
raddata=nrthdata;
radgroups=othtreelabels(:,18);
t = ClassificationTree.template('minleaf',1);
%model
rad_model = fitensemble(raddata,radgroups,'RusBoost',90,t,'type','classification');
model{19}=rad_model;

% SA vs others
sadata=nrthdata;
sagroups=othtreelabels(:,20);
t = ClassificationTree.template('minleaf',1);
%model
sa_model = fitensemble(sadata,sagroups,'RusBoost',90,t,'type','classification');
model{20}=sa_model;

% SB vs others
sbdata=nrthdata;
sbgroups=othtreelabels(:,21);
t = ClassificationTree.template('minleaf',1);
%model
sb_model = fitensemble(sbdata,sbgroups,'Bag',90,t,'type','classification');
model{21}=sb_model;

% STach vs others
stdata=nrthdata;
stgroups=othtreelabels(:,23);
t = ClassificationTree.template('minleaf',1);
%model
st_model = fitensemble(stdata,stgroups,'Bag',90,t,'type','classification');
model{22}=st_model;

% t wave abnormal vs others
tabdata=nrthdata;
tabgroups=othtreelabels(:,25);
t = ClassificationTree.template('minleaf',1);
%model
tab_model = fitensemble(tabdata,tabgroups,'RusBoost',90,t,'type','classification');
model{23}=tab_model;

% t wave inversion vs others
tinvdata=nrthdata;
tinvgroups=othtreelabels(:,26);
t = ClassificationTree.template('minleaf',1);
%model
tinv_model = fitensemble(tinvdata,tinvgroups,'RusBoost',90,t,'type','classification');
model{24}=tinv_model;


end

