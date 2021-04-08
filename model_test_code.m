function [score] = model_test_code(model,features,classes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    num_classes=length(classes);
    score=zeros(1,num_classes);
    for j=1:size(classes,2)
        classes_double(j)=str2double(classes{j});
    end
    scored_labels=[270492004	164889003	164890007	426627000	713427006	713426002	445118002	39732003	164909002	251146004	698252002	10370003	284470004	427172004	164947007	111975006	164917005	47665007	59118001	427393009	426177001	426783006	427084000	63593006	164934002	59931005	17338001];
    for j=1:size(scored_labels,2)
        scored_label_idx(j)=find(classes_double==scored_labels(j));
    end
    
    [lab_normal,score_normal]=predict(model{1},features);
    
    if lab_normal==1
        score(1,scored_label_idx(22))=score_normal(1,2)/sum(score_normal);
    else
       [lab_rythm,score_rythm]=predict(model{1,2},features);
       if lab_rythm==1
           [lab_af,score_af]=predict(model{3},features);
           [lab_flutter,score_flutter]=predict(model{4},features);
           [lab_brady,score_brady]=predict(model{5},features);
           [lab_pac,score_pac]=predict(model{6},features);
           [lab_pvc,score_pvc]=predict(model{7},features);
           [lab_pqt,score_pqt]=predict(model{8},features);
       
       
                score(1,[scored_label_idx(2) scored_label_idx(3) scored_label_idx(4) scored_label_idx(13) scored_label_idx(14) scored_label_idx(16)])=[score_af(1,2)/sum(score_af) score_flutter(1,2)/sum(score_flutter) score_brady(1,2)/sum(score_brady) score_pac(1,2)/sum(score_pac) score_pvc(1,2)/sum(score_pvc) score_pqt(1,2)/sum(score_pqt)];
           
       else
           [lab_idb,score_idb]=predict(model{9},features);
           [lab_crbbb,score_crbbb]=predict(model{10},features);
           [lab_irbbb,score_irbbb]=predict(model{11},features);
           [lab_lafb,score_lafb]=predict(model{12},features);
           [lab_lad,score_lad]=predict(model{13},features);
           [lab_lbbb,score_lbbb]=predict(model{14},features);
           [lab_lqrs,score_lqrs]=predict(model{15},features);
           [lab_nsivcd,score_nsivcd]=predict(model{16},features);
           [lab_pr,score_pr]=predict(model{17},features);
           [lab_qab,score_qab]=predict(model{18},features);
           [lab_rad,score_rad]=predict(model{19},features);
           [lab_sa,score_sa]=predict(model{20},features);
           [lab_sb,score_sb]=predict(model{21},features);
           [lab_st,score_st]=predict(model{22},features);
           [lab_tab,score_tab]=predict(model{23},features);
           [lab_tinv,score_tinv]=predict(model{24},features);
           
           score(1,[scored_label_idx(1) scored_label_idx(5) scored_label_idx(6) scored_label_idx(7) scored_label_idx(8) scored_label_idx(9) scored_label_idx(10) scored_label_idx(11) scored_label_idx(12) scored_label_idx(17) scored_label_idx(18) scored_label_idx(20) scored_label_idx(21) scored_label_idx(23) scored_label_idx(25) scored_label_idx(26)])=[score_idb(1,2)/sum(score_idb) score_crbbb(1,2)/sum(score_crbbb) score_irbbb(1,2)/sum(score_irbbb) score_lafb(1,2)/sum(score_lafb) score_lad(1,2)/sum(score_lad) score_lbbb(1,2)/sum(score_lbbb)...
               score_lqrs(1,2)/sum(score_lqrs) score_nsivcd(1,2)/sum(score_nsivcd) score_pr(1,2)/sum(score_pr) score_qab(1,2)/sum(score_qab) score_rad(1,2)/sum(score_rad) score_sa(1,2)/sum(score_sa) score_sb(1,2)/sum(score_sb) score_st(1,2)/sum(score_st) score_tab(1,2)/sum(score_tab) score_tinv(1,2)/sum(score_tinv)];
    
       end
    end

end

