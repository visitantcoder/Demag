function pooled = wscn_pool_paths(cells,target)
% RMS pooling across ALL paths:
% pooled(x,y)=sqrt(mean_p |C_p(x,y)|^2)

n=numel(cells);
if n==0
    pooled=zeros(target);
    return;
end

acc=zeros(target);
for p=1:n
    A=abs(double(cells{p}));
    if ndims(A)==3, A=A(:,:,1); end
    A=wscn_resize2d(A,target);
    acc=acc+A.^2;
end
pooled=sqrt(acc/n);
end
