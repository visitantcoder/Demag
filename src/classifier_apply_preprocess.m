function Zp = classifier_apply_preprocess(X,prep)
Z=bsxfun(@rdivide,bsxfun(@minus,double(X),prep.mu),prep.sigma);
Zp=Z*prep.coeff;
end
