function score = classifier_feature_scores(X,y)
% One-way between-class / within-class variance score.
% This is a transparent feature-ranking diagnostic, not a fitted classifier.

classes=unique(y(:));
mu=mean(X,1);
score=zeros(1,size(X,2));

for j=1:size(X,2)
    between=0;
    within=0;

    for c=1:numel(classes)
        xc=X(y==classes(c),j);
        if isempty(xc), continue; end

        muc=mean(xc);
        between=between+numel(xc)*(muc-mu(j))^2;
        within=within+sum((xc-muc).^2);
    end

    score(j)=between/(within+eps);
end
end
