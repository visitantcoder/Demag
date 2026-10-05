function RGB = capcsdp_white_channel(A,displayScale,gammaValue,baseColor)
% White-to-color rendering for one CAP-CSDP physical channel.
% Zero response is pure white.

A=double(A);
a=min(max(A/displayScale,0),1);
a=a.^gammaValue;

RGB=ones([size(A) 3]);

for q=1:3
    RGB(:,:,q)=1-a*(1-baseColor(q));
end

RGB=min(max(RGB,0),1);
end
