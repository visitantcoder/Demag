function scales = wscn_stage_common_scales(maps,P)
% STRICT publication scale:
% one display scale per stage, shared across:
%   all D-states + Br + Bt + Bz.
%
% Therefore RGB intensity really represents relative branch response inside
% the CAP-CSDP/WSCN representation space.

K=size(maps,1);
N=size(maps,2);
C=size(maps,3);
scales=zeros(K,1);

for k=1:K
    v=[];
    for i=1:N
        for c=1:C
            A=maps{k,i,c};
            v=[v; A(:)]; %#ok<AGROW>
        end
    end
    scales(k)=localRobustScale(v,P.WSCN.DisplayPercentile);
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
