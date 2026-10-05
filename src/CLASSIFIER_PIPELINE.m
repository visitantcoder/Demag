function CLASSIFIER_PIPELINE(ROOT)
P=wscn_default_config(ROOT);
C=classifier_default_config();

outRoot=fullfile(P.ResultsRoot,'classifier');
if ~exist(outRoot,'dir'), mkdir(outRoot); end

fprintf('\n============================================================\n');
fprintf(' CAP-CSDP + Channel-wise WSCN Classifier\n');
fprintf('============================================================\n');

sources=classifier_load_sources(P);

% Check expected classes.
classesDetected=unique([sources.severity]);
missing=setdiff(C.ExpectedClasses,classesDetected);

if ~isempty(missing)
    fprintf(2,'Warning: missing severity classes: %s\n',mat2str(missing));
end

[X,y,sourceID,augIndex,sourceName,featureNames,capRef] = ...
    classifier_build_dataset(sources,P,C);

[foldID,K,validationMode]=classifier_make_folds(y,sourceID,C);

fprintf('\nValidation mode: %s\n',validationMode);
fprintf('Cross-validation folds: %d\n',K);

if strcmp(validationMode,'PROTOTYPE_AUGMENTATION_CV')
    fprintf(2,'\n************************************************************\n');
    fprintf(2,' IMPORTANT SCIENTIFIC LIMITATION\n');
    fprintf(2,' Only one independent CSV is available for each severity.\n');
    fprintf(2,' The current CV separates augmented variants of the same\n');
    fprintf(2,' underlying waveform. It is useful for pipeline debugging,\n');
    fprintf(2,' but it is NOT a final paper generalization accuracy.\n');
    fprintf(2,'************************************************************\n\n');
end

models=classifier_available_models();
results=repmat(struct('name','','display','','ok',false,'message','', ...
    'pred',[],'metrics',[]),numel(models),1);

fprintf('\nCross-validating classifier candidates...\n');

for i=1:numel(models)
    fprintf('  %-24s ... ',models(i).display);

    R=classifier_cross_validate(X,y,foldID,C,models(i));
    results(i)=R;

    if R.ok
        fprintf('accuracy = %.2f%%, macro-F1 = %.2f%%\n', ...
            100*R.metrics.accuracy,100*R.metrics.macroF1);
    else
        fprintf('FAILED\n');
        fprintf('    %s\n',R.message);
    end
end

idxBest=classifier_choose_best(results,C);
best=results(idxBest);

fprintf('\nSelected final classifier: %s\n',best.display);
fprintf('CV accuracy: %.2f%%\n',100*best.metrics.accuracy);
fprintf('Macro F1:   %.2f%%\n',100*best.metrics.macroF1);

% Fit final preprocessing/model using all available classifier samples.
prep=classifier_fit_preprocess(X,C);
Z=classifier_apply_preprocess(X,prep);
finalModel=classifier_fit_model(Z,y,best.name);

bundle.classifierName=best.name;
bundle.classifierDisplayName=best.display;
bundle.model=finalModel;
bundle.preprocess=prep;
bundle.capRef=capRef;
bundle.P=P;
bundle.C=C;
bundle.classes=unique(y(:));
bundle.featureNames=featureNames;
bundle.validationMode=validationMode;

classifier_save_results( ...
    X,y,sourceID,augIndex,sourceName,featureNames,foldID, ...
    validationMode,results,idxBest,bundle,P,C);

% -------------------------------------------------------------------------
% Figures
% -------------------------------------------------------------------------
for m=1:numel(P.OutputModes)
    mode=P.OutputModes{m};
    style=wscn_style(mode);

    figDir=fullfile(outRoot,'figures',mode);
    if ~exist(figDir,'dir'), mkdir(figDir); end

    fig=classifier_plot_confusion( ...
        best.metrics,unique(y(:)),style, ...
        best.display);
    wscn_export_figure(fig,figDir,'Classifier_ConfusionMatrix',style);
    close(fig);

    fig=classifier_plot_pca(X,y,C,style,validationMode);
    wscn_export_figure(fig,figDir,'Classifier_PCA_FeatureSpace',style);
    close(fig);

    fig=classifier_plot_accuracy(results,style);
    wscn_export_figure(fig,figDir,'Classifier_ModelComparison',style);
    close(fig);

    fig=classifier_plot_feature_ranking(X,y,featureNames,C,style);
    wscn_export_figure(fig,figDir,'Classifier_TopWSCNFeatures',style);
    close(fig);
end

fprintf('\nClassifier outputs:\n');
fprintf('  %s\n',outRoot);
fprintf('\nImportant file:\n');
fprintf('  results/classifier/VALIDATION_STATUS.txt\n');
fprintf('\nTo classify one new CSV after training:\n');
fprintf('  PREDICT_NEW_CSV(''your_file.csv'')\n');
fprintf('============================================================\n\n');
end
