function idxBest = classifier_choose_best(results,C)
valid=find([results.ok]);

if isempty(valid)
    error('All classifier candidates failed.');
end

acc=zeros(numel(valid),1);
for i=1:numel(valid)
    acc(i)=results(valid(i)).metrics.accuracy;
end

bestAcc=max(acc);
cand=valid(abs(acc-bestAcc)<1e-12);

if numel(cand)==1
    idxBest=cand;
    return;
end

% Preference order for ties.
for p=1:numel(C.Preference)
    for j=1:numel(cand)
        if strcmp(results(cand(j)).name,C.Preference{p})
            idxBest=cand(j);
            return;
        end
    end
end

idxBest=cand(1);
end
