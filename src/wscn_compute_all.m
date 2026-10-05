function [maps,metrics] = wscn_compute_all(sf,tensors,info,P)
% maps{stage,state,channel}
% stages: Input, S0, U1, S1, U2, S2
%
% U1/U2/S1/S2 display maps use ALL-path RMS pooling.
% Quantitative energies are computed from RAW scattering paths before any
% resize/pooling used for visualization.

N=numel(tensors);
C=3; K=6;
maps=cell(K,N,C);

metrics.totalEnergy=zeros(N,C,3);
metrics.meanEnergyPerPath=zeros(N,C,3);
metrics.numPaths=zeros(C,3);

target=P.WSCN.DisplaySize;

fprintf('\nComputing channel-wise WSCN...\n');

for i=1:N
    fprintf('  %s\n',info.label{i});
    X=double(tensors{i});

    for c=1:C
        I=X(:,:,c);
        [S,U]=scatteringTransform(sf,I);

        if numel(S)<3 || numel(U)<3
            error('Expected 0th/1st/2nd-order 2-D scattering outputs.');
        end

        maps{1,i,c}=wscn_resize2d(I,target);
        maps{2,i,c}=wscn_pool_paths(S{1}.images,target);
        maps{3,i,c}=wscn_pool_paths(U{2}.coefficients,target);
        maps{4,i,c}=wscn_pool_paths(S{2}.images,target);
        maps{5,i,c}=wscn_pool_paths(U{3}.coefficients,target);
        maps{6,i,c}=wscn_pool_paths(S{3}.images,target);

        for ord=1:3
            imgs=S{ord}.images;
            e=zeros(numel(imgs),1);
            for p=1:numel(imgs)
                A=abs(double(imgs{p}));
                e(p)=mean(A(:).^2);
            end
            metrics.totalEnergy(i,c,ord)=sum(e);
            metrics.meanEnergyPerPath(i,c,ord)=mean(e);
            metrics.numPaths(c,ord)=numel(imgs);
        end
    end
end

i0=find(info.severity==0,1);
if isempty(i0), i0=1; end

metrics.relativeToD0=zeros(size(metrics.totalEnergy));
metrics.energyRatio=zeros(size(metrics.totalEnergy));

for c=1:C
    for ord=1:3
        den=metrics.totalEnergy(i0,c,ord);
        if den>0
            metrics.relativeToD0(:,c,ord)=metrics.totalEnergy(:,c,ord)/den;
        else
            metrics.relativeToD0(:,c,ord)=NaN;
        end
    end
end

for i=1:N
    for c=1:C
        den=sum(metrics.totalEnergy(i,c,:));
        if den>0
            metrics.energyRatio(i,c,:)=metrics.totalEnergy(i,c,:)/den;
        else
            metrics.energyRatio(i,c,:)=NaN;
        end
    end
end
end
