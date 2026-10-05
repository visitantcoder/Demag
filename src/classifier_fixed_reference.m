function ref = classifier_fixed_reference(sources,P)
% One fixed CAP-CSDP reference for the complete classifier development set.
%
% For the CURRENT prototype this reproduces the same fixed-reference idea
% as the publication CAP-CSDP pipeline.
%
% For final external validation, freeze this reference using the training
% set and apply it unchanged to independent test data.

allBr=vertcat(sources.Br);
allBt=vertcat(sources.Bt);
allBz=vertcat(sources.Bz);

ref.Ar=P.CAP.ReferenceMargin*max(abs(allBr));
ref.At=P.CAP.ReferenceMargin*max(abs(allBt));
ref.Az=P.CAP.ReferenceMargin*max(abs(allBz));
end
