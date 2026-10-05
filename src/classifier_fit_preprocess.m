function prep = classifier_fit_preprocess(X,C)
prep.mu=mean(X,1);
prep.sigma=std(X,0,1);
prep.sigma(~isfinite(prep.sigma) | prep.sigma<eps)=1;

Z=bsxfun(@rdivide,bsxfun(@minus,X,prep.mu),prep.sigma);

[~,S,V]=svd(Z,'econ');
sv=diag(S);

if size(Z,1)>1
    latent=(sv.^2)/(size(Z,1)-1);
else
    latent=sv.^2;
end

if sum(latent)>0
    explained=100*latent/sum(latent);
else
    explained=zeros(size(latent));
end

cum=cumsum(explained)/100;
idx=find(cum>=C.PCAVarianceToKeep,1,'first');

if isempty(idx)
    idx=size(V,2);
end

nPC=max(C.MinPC,idx);
nPC=min(nPC,C.MaxPC);
nPC=min(nPC,size(V,2));
nPC=max(1,nPC);

prep.coeff=V(:,1:nPC);
prep.nPC=nPC;
prep.explained=explained;
prep.cumulativeExplained=sum(explained(1:nPC));
end
