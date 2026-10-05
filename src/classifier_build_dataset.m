function [X,y,sourceID,augIndex,sourceName,featureNames,capRef] = ...
    classifier_build_dataset(sources,P,C)
% Build/cache CAP-CSDP -> WSCN feature dataset.

cacheDir=fullfile(P.ResultsRoot,'classifier','cache');
if ~exist(cacheDir,'dir'), mkdir(cacheDir); end

cacheFile=fullfile(cacheDir,'WSCN_Classifier_FeatureCache.mat');
signature=classifier_signature(sources,P,C);

if C.UseFeatureCache && exist(cacheFile,'file')==2
    S=load(cacheFile);
    if isfield(S,'signature') && strcmp(S.signature,signature)
        fprintf('\nUsing cached classifier WSCN features.\n');
        X=S.X;
        y=S.y;
        sourceID=S.sourceID;
        augIndex=S.augIndex;
        sourceName=S.sourceName;
        featureNames=S.featureNames;
        capRef=S.capRef;
        return;
    end
end

capRef=classifier_fixed_reference(sources,P);

fprintf('\nClassifier CAP-CSDP fixed references:\n');
fprintf('  Ar = %.12g\n',capRef.Ar);
fprintf('  At = %.12g\n',capRef.At);
fprintf('  Az = %.12g\n',capRef.Az);

sf=waveletScattering2( ...
    'ImageSize',[P.CAP.ImageSize P.CAP.ImageSize], ...
    'InvarianceScale',P.WSCN.InvarianceScale, ...
    'NumRotations',P.WSCN.NumRotations);

nRows=numel(sources)*C.AugmentationsPerSource;

X=[];
y=zeros(nRows,1);
sourceID=zeros(nRows,1);
augIndex=zeros(nRows,1);
sourceName=cell(nRows,1);
featureNames={};

r=0;

fprintf('\nExtracting augmented CAP-CSDP/WSCN features...\n');
fprintf('This is the slowest step and is cached after the first run.\n\n');

for s=1:numel(sources)
    for a=1:C.AugmentationsPerSource
        r=r+1;

        fprintf('  [%3d/%3d] %-20s augmentation %d/%d\n', ...
            r,nRows,sources(s).name,a,C.AugmentationsPerSource);

        srcAug=classifier_augment_source(sources(s),a,C);
        tensor=classifier_build_cap_tensor(srcAug,capRef,P);

        [fv,fn]=classifier_extract_features(sf,tensor,P);

        if isempty(X)
            X=zeros(nRows,numel(fv));
            featureNames=fn;
        end

        X(r,:)=fv;
        y(r)=sources(s).severity;
        sourceID(r)=sources(s).sourceID;
        augIndex(r)=a;
        sourceName{r}=sources(s).name;
    end
end

save(cacheFile,'X','y','sourceID','augIndex','sourceName', ...
    'featureNames','capRef','signature','P','C','-v7.3');

fprintf('\nFeature extraction complete: %d samples x %d features.\n', ...
    size(X,1),size(X,2));
end
