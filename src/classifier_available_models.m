function models = classifier_available_models()
models=struct('name',{},'display',{});

models(end+1)=struct( ...
    'name','nearest_centroid', ...
    'display','Nearest centroid');

if exist('fitcdiscr','file')==2
    models(end+1)=struct('name','lda','display','LDA');
end

if exist('fitcknn','file')==2
    models(end+1)=struct('name','knn','display','kNN');
end

if exist('fitcecoc','file')==2 && exist('templateSVM','file')==2
    models(end+1)=struct('name','svm_linear','display','ECOC-SVM (linear)');
    models(end+1)=struct('name','svm_rbf','display','ECOC-SVM (RBF)');
end
end
