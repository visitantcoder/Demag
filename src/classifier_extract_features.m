function [f,names] = classifier_extract_features(sf,tensor,P)
% Compact, interpretable WSCN feature vector.
%
% No D0-relative features are used here because the classifier must be able
% to process one unknown sample independently.
%
% For each physical channel:
%   CAP-CSDP descriptors:
%     mean, std, RMS, max, active fraction
%
%   For WSCN order 0/1/2 path energies:
%     total, mean, std, max, normalized entropy, top-10%-energy fraction
%
% Cross-channel ratios of total-order energies are appended afterwards.

f=[];
names={};

channelTotals=zeros(3,3);

for c=1:3
    ch=P.ChannelShort{c};
    A=double(tensor(:,:,c));

    capVals=[ ...
        mean(A(:)), ...
        std(A(:)), ...
        sqrt(mean(A(:).^2)), ...
        max(A(:)), ...
        mean(A(:)>0.02)];

    capNames={ ...
        [ch '_CAP_Mean'], ...
        [ch '_CAP_Std'], ...
        [ch '_CAP_RMS'], ...
        [ch '_CAP_Max'], ...
        [ch '_CAP_ActiveFrac']};

    f=[f capVals]; %#ok<AGROW>
    names=[names capNames]; %#ok<AGROW>

    [S,~]=scatteringTransform(sf,A);

    for ord=1:3
        imgs=S{ord}.images;
        e=zeros(numel(imgs),1);

        for p=1:numel(imgs)
            B=abs(double(imgs{p}));
            e(p)=mean(B(:).^2);
        end

        totalE=sum(e);
        meanE=mean(e);
        stdE=std(e);
        maxE=max(e);

        if totalE>0
            q=e/totalE;
            q=q(q>0);

            if numel(e)>1
                ent=-sum(q.*log(q))/log(numel(e));
            else
                ent=0;
            end

            es=sort(e,'descend');
            ntop=max(1,ceil(0.10*numel(es)));
            topFrac=sum(es(1:ntop))/totalE;
        else
            ent=0;
            topFrac=0;
        end

        vals=[totalE meanE stdE maxE ent topFrac];

        prefix=[ch '_O' num2str(ord-1)];
        nms={ ...
            [prefix '_TotalE'], ...
            [prefix '_MeanPathE'], ...
            [prefix '_StdPathE'], ...
            [prefix '_MaxPathE'], ...
            [prefix '_PathEntropy'], ...
            [prefix '_Top10Frac']};

        f=[f vals]; %#ok<AGROW>
        names=[names nms]; %#ok<AGROW>

        channelTotals(c,ord)=totalE;
    end
end

% Cross-channel order-energy ratios.
% eps prevents division-by-zero and does not depend on the unknown label.
for ord=1:3
    o=ord-1;

    vals=[ ...
        channelTotals(1,ord)/(channelTotals(2,ord)+eps), ...
        channelTotals(3,ord)/(channelTotals(2,ord)+eps), ...
        channelTotals(1,ord)/(channelTotals(3,ord)+eps)];

    nms={ ...
        ['O' num2str(o) '_Br_over_Bt'], ...
        ['O' num2str(o) '_Bz_over_Bt'], ...
        ['O' num2str(o) '_Br_over_Bz']};

    f=[f vals]; %#ok<AGROW>
    names=[names nms]; %#ok<AGROW>
end

f=double(f(:).');
end
