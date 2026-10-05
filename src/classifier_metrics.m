function M = classifier_metrics(yTrue,yPred,classes)
Cmat=classifier_confusion(yTrue,yPred,classes);

acc=sum(diag(Cmat))/max(1,sum(Cmat(:)));

precision=zeros(numel(classes),1);
recall=zeros(numel(classes),1);
f1=zeros(numel(classes),1);

for i=1:numel(classes)
    tp=Cmat(i,i);
    fp=sum(Cmat(:,i))-tp;
    fn=sum(Cmat(i,:))-tp;

    precision(i)=tp/max(1,tp+fp);
    recall(i)=tp/max(1,tp+fn);

    if precision(i)+recall(i)>0
        f1(i)=2*precision(i)*recall(i)/(precision(i)+recall(i));
    else
        f1(i)=0;
    end
end

M.accuracy=acc;
M.macroPrecision=mean(precision);
M.macroRecall=mean(recall);
M.macroF1=mean(f1);
M.confusion=Cmat;
M.classPrecision=precision;
M.classRecall=recall;
M.classF1=f1;
end
