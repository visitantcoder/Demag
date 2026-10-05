function RGB = capcsdp_white_rgb(E,displayScale,gammaValue)
% Convert a zero-background RGB energy tensor to a WHITE-background
% publication rendering without changing the underlying numerical data.
%
% Numerical tensor convention:
%   zero response -> [0 0 0]
%
% Figure convention:
%   zero response -> white
%   strong Br      -> red
%   strong Bt      -> green
%   strong Bz      -> blue
%   overlapping branches -> additive RGB hue
%
% The transformation is ONLY for visualization.

E=double(E);

R=min(max(E(:,:,1)/displayScale,0),1);
G=min(max(E(:,:,2)/displayScale,0),1);
B=min(max(E(:,:,3)/displayScale,0),1);

I=max(cat(3,R,G,B),[],3);
den=max(I,eps);

hR=R./den;
hG=G./den;
hB=B./den;

alpha=I.^gammaValue;

RGB=zeros(size(E));
RGB(:,:,1)=1-alpha+alpha.*hR;
RGB(:,:,2)=1-alpha+alpha.*hG;
RGB(:,:,3)=1-alpha+alpha.*hB;

RGB=min(max(RGB,0),1);
end
