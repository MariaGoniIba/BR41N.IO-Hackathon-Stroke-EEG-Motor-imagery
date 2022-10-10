function Results = RFsimple(datatrain, datatest, ClassesTrain, ClassesTest)

% Shuffle the data
idx = randperm(size(datatrain,1));
datatrain = datatrain(idx,:);
ClassesTrain = ClassesTrain(idx);
idx = randperm(size(datatest,1));
datatest = datatest(idx,:);
ClassesTest = ClassesTest(idx);

nfeat = ceil(sqrt(size(datatrain,2)));
RFmodel = TreeBagger(100,datatrain,ClassesTrain,'Method', 'classification', 'OOBPrediction', 'on','NumPredictorsToSample', nfeat);

[classpredict, score] = RFmodel.predict(datatest);
score=score(:,2);

classpredict = str2num(cell2mat(classpredict));
classpredict = classpredict';

Results.TP = length(find(ClassesTest==1 & classpredict==1));
Results.TN = length(find(ClassesTest==0 & classpredict==0));
Results.FP = length(find(ClassesTest==0 & classpredict==1));
Results.FN = length(find(ClassesTest==1 & classpredict==0));
Results.Sens=Results.TP/(Results.TP+Results.FN);
Results.Spec=Results.TN/(Results.TN+Results.FP);
Results.BalAcc=(Results.Sens+Results.Spec)/2;
Results.Precision=Results.TP/(Results.TP+Results.FP);
Results.Recall=Results.TP/(Results.TP+Results.FN);
Results.F1Score=2*((Results.Recall*Results.Precision)/(Results.Recall+Results.Precision));
[XX,YY,TT,Results.AUC]=perfcurve(ClassesTest,score,1,'XCrit', 'fpr', 'YCrit', 'sens', 'Xvals', [0:0.01:1], 'UseNearest', 'off');
%Results.weights=RFmodel.OOBPermutedPredictorDeltaError;