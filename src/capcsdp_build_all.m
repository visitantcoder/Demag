function [tensors,ref] = capcsdp_build_all(dataRaw,info,P)
% Final channel-wise fixed-reference amplitude-preserving CSDP.

allBr=vertcat(dataRaw.Br);
allBt=vertcat(dataRaw.Bt);
allBz=vertcat(dataRaw.Bz);

ref.Ar=P.CAP.ReferenceMargin*max(abs(allBr));
ref.At=P.CAP.ReferenceMargin*max(abs(allBt));
ref.Az=P.CAP.ReferenceMargin*max(abs(allBz));

fprintf('\nCAP-CSDP fixed references\n');
fprintf('  Ar = %.12g\n',ref.Ar);
fprintf('  At = %.12g\n',ref.At);
fprintf('  Az = %.12g\n',ref.Az);
fprintf('  lag=%d, delta=%.1f deg, psi=%.1f deg\n', ...
    P.CAP.Lag,P.CAP.DeltaDeg,P.CAP.PsiDeg);

outDir=fullfile(P.ResultsRoot,'cap_csdp_tensors');
if ~exist(outDir,'dir'), mkdir(outDir); end

N=numel(dataRaw);
tensors=cell(N,1);

for i=1:N
    Er=capcsdp_render_channel(dataRaw(i).Br,ref.Ar,P.CAP);
    Et=capcsdp_render_channel(dataRaw(i).Bt,ref.At,P.CAP);
    Ez=capcsdp_render_channel(dataRaw(i).Bz,ref.Az,P.CAP);

    CAP_CSDP_energy_tensor=cat(3,Er,Et,Ez); %#ok<NASGU>
    tensors{i}=CAP_CSDP_energy_tensor;

    reference=ref; %#ok<NASGU>
    params=P.CAP; %#ok<NASGU>
    save(fullfile(outDir,['CAP_CSDP_' info.label{i} '_tensor.mat']), ...
        'CAP_CSDP_energy_tensor','reference','params');
end
end
