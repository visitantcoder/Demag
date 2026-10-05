function sig = classifier_signature(sources,P,C)
sig='';

for i=1:numel(sources)
    d=dir(sources(i).file);
    sig=[sig sprintf('%s|%d|%.8f;',sources(i).name,d.bytes,d.datenum)]; %#ok<AGROW>
end

sig=[sig sprintf('CAP=%d,%d,%.8g,%.8g,%.8g;', ...
    P.CAP.ImageSize,P.CAP.Lag,P.CAP.DeltaDeg,P.CAP.PsiDeg,P.CAP.RenderGain)];

sig=[sig sprintf('WSCN=%.8g,%s;', ...
    P.WSCN.InvarianceScale,mat2str(P.WSCN.NumRotations))];

sig=[sig sprintf('AUG=%d,%.8g,%.8g,%.8g,%d;', ...
    C.AugmentationsPerSource,C.GainStd,C.MinSNRdB,C.MaxSNRdB, ...
    C.EnableCircularShift)];
end
