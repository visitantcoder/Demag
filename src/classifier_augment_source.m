function out = classifier_augment_source(src,augIndex,C)
% Deterministic, mild signal augmentation.
%
% augIndex=1 is the exact original signal.
% augIndex>1 may apply:
%   - circular phase shift
%   - small amplitude gain jitter
%   - high-SNR Gaussian noise
%
% This is for training robustness. It does NOT create independent physical
% experiments and therefore cannot replace additional simulations/tests.

out=src;

if augIndex==1
    return;
end

seed=C.RandomSeed + 10007*src.sourceID + 97*augIndex;
rng(seed,'twister');

N=numel(src.Br);

if C.EnableCircularShift
    shift=randi([0 max(0,N-1)],1,1);
else
    shift=0;
end

globalGain=1 + C.GainStd*randn(1,1);
channelGain=1 + 0.5*C.GainStd*randn(1,3);

snrDb=C.MinSNRdB + (C.MaxSNRdB-C.MinSNRdB)*rand(1,1);

out.Br=localPerturb(src.Br,shift,globalGain*channelGain(1),snrDb);
out.Bt=localPerturb(src.Bt,shift,globalGain*channelGain(2),snrDb);
out.Bz=localPerturb(src.Bz,shift,globalGain*channelGain(3),snrDb);
end

function y=localPerturb(x,shift,gain,snrDb)
x=circshift(double(x(:)),shift);
x=gain*x;

rmsx=sqrt(mean(x.^2));
if rmsx>0
    noiseRms=rmsx/(10^(snrDb/20));
    x=x+noiseRms*randn(size(x));
end

y=x;
end
