function [globalScale,channelScales] = capcsdp_display_scales(tensors,P)
% CAP-CSDP publication display scales.
%
% globalScale:
%   ONE common scale over all D-states + Br/Bt/Bz.  Use this for the main
%   RGB paper figure so evolution is not hidden by independent stretching.
%
% channelScales:
%   One scale per physical channel, common across D-states.  Use this only
%   for the detailed 3-row channel figure where the goal is morphology.

N=numel(tensors);
channelScales=zeros(1,3);

allValues=[];
for i=1:N
    X=double(tensors{i});
    allValues=[allValues; X(:)]; %#ok<AGROW>
end
globalScale=localRobustScale(allValues,P.CAP.DisplayPercentile);

for c=1:3
    v=[];
    for i=1:N
        A=double(tensors{i}(:,:,c));
        v=[v; A(:)]; %#ok<AGROW>
    end
    channelScales(c)=localRobustScale(v,P.CAP.DisplayPercentile);
end
end

function sc=localRobustScale(v,p)
v=v(isfinite(v) & v>=0);
if isempty(v), sc=1; return; end

v=sort(v(:));
p=max(0,min(100,p));
pos=1+(numel(v)-1)*p/100;
lo=floor(pos);
hi=ceil(pos);

if lo==hi
    sc=v(lo);
else
    a=pos-lo;
    sc=(1-a)*v(lo)+a*v(hi);
end

if ~(isfinite(sc) && sc>0), sc=max(v); end
if ~(isfinite(sc) && sc>0), sc=1; end
end
