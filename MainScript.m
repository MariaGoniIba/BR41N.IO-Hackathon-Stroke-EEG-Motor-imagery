clc 
clear
close all

lab = ["_pre_training","_pre_test","_post_training","_post_test"];
experiment = [append("P1", lab) append("P2", lab) append("P3", lab)];

fs = 256;
timeslot = 3;
initimeslot = 1.5;

disp (['Results time slot ', num2str(timeslot), ' seconds starting at ', num2str(initimeslot), ' seconds'])
for exp = 1:2:length(experiment)-1
    load(experiment(exp))
    datatrain = y; trigtrain = trig;
    load(experiment(exp+1));
    datatest = y; trigtest = trig;
    clear y trig 
 
    % Preprocessing
    [righttrain, lefttrain] = preprocessing(datatrain, trigtrain, fs);
    [righttest, lefttest] = preprocessing(datatest, trigtest, fs);

    % Trim time slot
    righttrain = righttrain((initimeslot*fs:fs*2.5-1),:);
    lefttrain = lefttrain((initimeslot*fs:fs*2.5-1),:);
    righttest = righttest((initimeslot*fs:fs*2.5-1),:);
    lefttest = lefttest((initimeslot*fs:fs*2.5-1),:);

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
    Results(exp) = RFsimple(datatrain, datatest, ClassesTrain, ClassesTest);
end
% delete even empty cells
Results = struct2table(Results(1:2:length(experiment)-1));

Labels = ["P1_pre" "P1_post" "P2_pre" "P2_pos" "P3_pre" "P3_pos"];
Results = [array2table(Labels') Results]


