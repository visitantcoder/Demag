function classifier_save_results( ...
    X,y,sourceID,augIndex,sourceName,featureNames,foldID, ...
    validationMode,results,idxBest,bundle,P,C)

outDir=fullfile(P.ResultsRoot,'classifier');
if ~exist(outDir,'dir'), mkdir(outDir); end

tableDir=fullfile(outDir,'tables');
if ~exist(tableDir,'dir'), mkdir(tableDir); end

modelDir=fullfile(outDir,'model');
if ~exist(modelDir,'dir'), mkdir(modelDir); end

% -------------------------------------------------------------------------
% Feature table
% -------------------------------------------------------------------------
T=table(y,sourceID,augIndex,sourceName,foldID, ...
    'VariableNames',{'SeverityPercent','SourceID','AugmentationIndex', ...
                     'SourceFile','CVFold'});

for j=1:numel(featureNames)
    vn=classifier_safe_feature_name(featureNames{j});
    T.(vn)=X(:,j);
end

writetable(T,fullfile(tableDir,'WSCN_Classifier_Features.csv'));

% -------------------------------------------------------------------------
% Model comparison
% -------------------------------------------------------------------------
rows={};
r=0;

for i=1:numel(results)
    r=r+1;

    if results(i).ok
        rows(r,:)={ ...
            results(i).display, ...
            results(i).metrics.accuracy, ...
            results(i).metrics.macroPrecision, ...
            results(i).metrics.macroRecall, ...
            results(i).metrics.macroF1, ...
            strcmp(results(i).name,results(idxBest).name), ...
            ''}; %#ok<AGROW>
    else
        rows(r,:)={ ...
            results(i).display,NaN,NaN,NaN,NaN,false,results(i).message}; %#ok<AGROW>
    end
end

Tm=cell2table(rows,'VariableNames', ...
    {'Classifier','Accuracy','MacroPrecision','MacroRecall','MacroF1', ...
     'SelectedFinalModel','Message'});

writetable(Tm,fullfile(tableDir,'Classifier_Model_Comparison.csv'));

% -------------------------------------------------------------------------
% CV predictions for selected model
% -------------------------------------------------------------------------
best=results(idxBest);

Tp=table(y,best.pred,sourceID,augIndex,sourceName,foldID, ...
    'VariableNames',{'TrueSeverity','PredictedSeverity','SourceID', ...
                     'AugmentationIndex','SourceFile','CVFold'});

writetable(Tp,fullfile(tableDir,'Classifier_SelectedModel_CV_Predictions.csv'));

% Confusion matrix table.
classes=unique(y(:));
Cmat=best.metrics.confusion;

varNames=cell(numel(classes)+1,1);
varNames{1}='TrueClass';
for j=1:numel(classes)
    varNames{j+1}=sprintf('Pred_D%d',classes(j));
end

cellData=cell(numel(classes),numel(classes)+1);
for i=1:numel(classes)
    cellData{i,1}=sprintf('D%d',classes(i));
    for j=1:numel(classes)
        cellData{i,j+1}=Cmat(i,j);
    end
end

Tc=cell2table(cellData,'VariableNames',varNames);
writetable(Tc,fullfile(tableDir,'Classifier_SelectedModel_ConfusionMatrix.csv'));

% Feature ranking.
score=classifier_feature_scores(X,y);
[scoreSorted,ord]=sort(score,'descend');
Tf=table(featureNames(ord).',scoreSorted.', ...
    'VariableNames',{'Feature','DiscriminationScore'});
writetable(Tf,fullfile(tableDir,'Classifier_Feature_Ranking.csv'));

% -------------------------------------------------------------------------
% Validation warning / methodology note
% -------------------------------------------------------------------------
fid=fopen(fullfile(outDir,'VALIDATION_STATUS.txt'),'w');
fprintf(fid,'Validation mode: %s\n\n',validationMode);

if strcmp(validationMode,'PROTOTYPE_AUGMENTATION_CV')
    fprintf(fid,'IMPORTANT: CURRENT RESULTS ARE PROTOTYPE RESULTS ONLY.\n');
    fprintf(fid,'The bundled dataset contains only one independent CSV per severity.\n');
    fprintf(fid,'Cross-validation therefore separates synthetic augmentations, not independent physical runs.\n');
    fprintf(fid,'Do NOT report this CV accuracy as final paper generalization accuracy.\n\n');
    fprintf(fid,'For paper-valid classification, add independent files such as:\n');
    fprintf(fid,'D0_run01.csv, D0_run02.csv, ...\n');
    fprintf(fid,'D10_run01.csv, D10_run02.csv, ...\n');
    fprintf(fid,'etc.\n');
    fprintf(fid,'When every severity has at least two source files, the pipeline automatically switches to GROUPED_BY_SOURCE_FILE.\n');
else
    fprintf(fid,'Source-file grouped cross-validation is active.\n');
    fprintf(fid,'All augmentations originating from one CSV stay in the same fold.\n');
end

fprintf(fid,'\nSelected classifier: %s\n',best.display);
fprintf(fid,'Cross-validation accuracy: %.6f\n',best.metrics.accuracy);
fprintf(fid,'Macro F1: %.6f\n',best.metrics.macroF1);
fclose(fid);

save(fullfile(modelDir,'WSCN_Classifier_FinalModel.mat'),'bundle','-v7.3');
save(fullfile(outDir,'Classifier_AllResults.mat'), ...
    'X','y','sourceID','augIndex','sourceName','featureNames','foldID', ...
    'validationMode','results','idxBest','C','-v7.3');
end
