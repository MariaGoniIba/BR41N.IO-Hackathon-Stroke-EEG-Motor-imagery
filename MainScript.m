clc 
clear
close all

lab = ["_pre_training","_pre_test","_post_training","_post_test"];
experiment = [append("P1", lab) append("P2", lab) append("P3", lab)];

fs = 256;

y_test = [];
for exp = 1:2:length(experiment)-1
    load(experiment(exp))
    datatrain = y; trigtrain = trig;
    load(experiment(exp+1));
    datatest = y; trigtest = trig;
    clear y trig 
 
    % Preprocessing
    [righttrain, lefttrain] = preprocessing(datatrain, trigtrain, fs);
    [righttest, lefttest] = preprocessing(datatest, trigtest, fs);

    % Feature extraction
    [frighttrain, flefttrain] = features(righttrain, lefttrain, fs);
    [frighttest, flefttest] = features(righttest, lefttest, fs);
    
    % Data matrices
    datatrain = [frighttrain'; flefttrain'];
    datatest = [frighttest'; flefttest'];
    ClassesTrain = [zeros(1,size(frighttrain,2)) ones(1,size(flefttrain,2))];
    ClassesTest = [zeros(1,size(frighttest,2)) ones(1,size(flefttest,2))];
    
    % Classification
    % RF
    ResultsRF(exp) = RFsimple(datatrain, datatest, ClassesTrain, ClassesTest);
    % SVM
    ResultsSVM(exp) = SVMlinear(datatrain, datatest, ClassesTrain, ClassesTest);
end
% delete even empty cells
ResultsRF = struct2table(ResultsRF(1:2:length(experiment)-1));
ResultsSVM = struct2table(ResultsSVM(1:2:length(experiment)-1));

disp('Results for a random forest')
Labels = ["P1_pre" "P1_post" "P2_pre" "P2_pos" "P3_pre" "P3_pos"];
ResultsRF = [array2table(Labels') ResultsRF]

disp('Results for a linear SVM')
Labels = ["P1_pre" "P1_post" "P2_pre" "P2_pos" "P3_pre" "P3_pos"];
ResultsSVM = [array2table(Labels') ResultsSVM]


