function R = classifier_cross_validate(X,y,foldID,C,modelInfo)
classes=unique(y(:));
K=max(foldID);
pred=nan(size(y));
ok=true;
message='';

for fold=1:K
    tr=foldID~=fold;
    te=foldID==fold;

    try
        prep=classifier_fit_preprocess(X(tr,:),C);
        Xtr=classifier_apply_preprocess(X(tr,:),prep);
        Xte=classifier_apply_preprocess(X(te,:),prep);

        mdl=classifier_fit_model(Xtr,y(tr),modelInfo.name);
        pred(te)=classifier_predict_model(mdl,Xte,modelInfo.name);
    catch ME
        ok=false;
        message=ME.message;
        break;
    end
end

R.name=modelInfo.name;
R.display=modelInfo.display;
R.ok=ok;
R.message=message;
R.pred=pred;

if ok && all(isfinite(pred))
    R.metrics=classifier_metrics(y,pred,classes);
else
    R.metrics=[];
end
end
