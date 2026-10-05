function scales = wscn_channel_scales(maps,P)
% Diagnostic scale: each stage+channel has one common scale across D-states.
K=size(maps,1);
N=size(maps,2);
C=size(maps,3);
scales=zeros(K,C);

for k=1:K
    for c=1:C
        v=[];
        for i=1:N
            A=maps{k,i,c};
            v=[v; A(:)]; %#ok<AGROW>
        end
        scales(k,c)=localRobustScale(v,P.WSCN.DisplayPercentile);
    end
end
end

function sc=localRobustScale(v,p)
v=v(isfinite(v) & v>=0);
if isempty(v), sc=1; return; end
v=sort(v(:));
pos=1+(numel(v)-1)*max(0,min(100,p))/100;
lo=floor(pos); hi=ceil(pos);
if lo==hi
    sc=v(lo);
else
    a=pos-lo;
    sc=(1-a)*v(lo)+a*v(hi);
end
if ~(isfinite(sc) && sc>0), sc=max(v); end
if ~(isfinite(sc) && sc>0), sc=1; end
end
