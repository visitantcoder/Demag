function Cmat = classifier_confusion(yTrue,yPred,classes)
Cmat=zeros(numel(classes));

for i=1:numel(classes)
    for j=1:numel(classes)
        Cmat(i,j)=sum(yTrue==classes(i) & yPred==classes(j));
    end
end
end
