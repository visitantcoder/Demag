function [foldID,K,validationMode] = classifier_make_folds(y,sourceID,C)
classes=unique(y(:));
nClass=numel(classes);

sourceCount=zeros(nClass,1);
for i=1:nClass
    sourceCount(i)=numel(unique(sourceID(y==classes(i))));
end

minSources=min(sourceCount);

rng(C.RandomSeed,'twister');

if minSources>=2
    % Strictly keep every original source file inside a single fold.
    K=min(C.MaxFolds,minSources);
    foldID=zeros(size(y));

    for i=1:nClass
        cls=classes(i);
        src=unique(sourceID(y==cls));
        src=src(randperm(numel(src)));

        for j=1:numel(src)
            fold=mod(j-1,K)+1;
            foldID(sourceID==src(j))=fold;
        end
    end

    validationMode='GROUPED_BY_SOURCE_FILE';
else
    % Current bundled data: one source file per class.
    % Stratifying augmented variants can test robustness/debugging, but
    % cannot estimate generalization to an independent simulation/run.
    classN=zeros(nClass,1);
    for i=1:nClass
        classN(i)=sum(y==classes(i));
    end

    K=min(C.MaxFolds,min(classN));
    K=max(2,K);
    foldID=zeros(size(y));

    for i=1:nClass
        idx=find(y==classes(i));
        idx=idx(randperm(numel(idx)));

        for j=1:numel(idx)
            foldID(idx(j))=mod(j-1,K)+1;
        end
    end

    validationMode='PROTOTYPE_AUGMENTATION_CV';
end
end
