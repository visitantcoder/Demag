function wscn_save_audit(data,maps,metrics,info,P,npaths,stageScales,channelScales,inputSource,capRef)
outDir=fullfile(P.ResultsRoot,'audit');
if ~exist(outDir,'dir'), mkdir(outDir); end

% -------------------------------------------------------------------------
% 1) Input background audit
% -------------------------------------------------------------------------
rows={};
r=0;
for i=1:numel(info.severity)
    for c=1:3
        A=double(data{i}(:,:,c));
        corner=[A(1:10,1:10); A(1:10,end-9:end); ...
                A(end-9:end,1:10); A(end-9:end,end-9:end)];
        r=r+1;
        rows(r,:)={info.label{i},P.ChannelShort{c}, ...
            min(A(:)),max(A(:)),mean(A(:)==0),mean(corner(:))}; %#ok<AGROW>
    end
end
Tbg=cell2table(rows,'VariableNames', ...
    {'State','Channel','Min','Max','ZeroFraction','CornerMean'});
writetable(Tbg,fullfile(outDir,'WSCN_InputBackground_Audit.csv'));

% -------------------------------------------------------------------------
% 2) Numerical process-map audit
% -------------------------------------------------------------------------
rows={}; r=0;
for k=1:size(maps,1)
    for i=1:numel(info.severity)
        for c=1:3
            A=double(maps{k,i,c});
            r=r+1;
            rows(r,:)={info.label{i},P.ChannelShort{c},P.StageLabels{k}, ...
                min(A(:)),max(A(:)),mean(A(:)),std(A(:)), ...
                sum(~isfinite(A(:))),sum(A(:)<0)}; %#ok<AGROW>
        end
    end
end
Tmp=cell2table(rows,'VariableNames', ...
    {'State','Channel','Stage','Min','Max','Mean','Std','NonFiniteCount','NegativeCount'});
writetable(Tmp,fullfile(outDir,'WSCN_ProcessMap_Numerical_Audit.csv'));

% -------------------------------------------------------------------------
% 3) Strict energy long table
% -------------------------------------------------------------------------
rows={}; r=0;
for i=1:numel(info.severity)
    for c=1:3
        for ord=0:2
            r=r+1;
            rows(r,:)={info.label{i},info.severity(i),P.ChannelShort{c},ord, ...
                metrics.numPaths(c,ord+1), ...
                metrics.totalEnergy(i,c,ord+1), ...
                metrics.meanEnergyPerPath(i,c,ord+1), ...
                metrics.relativeToD0(i,c,ord+1), ...
                metrics.energyRatio(i,c,ord+1)}; %#ok<AGROW>
        end
    end
end
Te=cell2table(rows,'VariableNames', ...
    {'State','SeverityPercent','Channel','Order','NumPaths', ...
     'TotalEnergy','MeanEnergyPerPath','RelativeToD0','OrderEnergyFraction'});
writetable(Te,fullfile(outDir,'WSCN_OrderEnergy_Strict_Long.csv'));

% -------------------------------------------------------------------------
% 4) Wide energy table for convenient plotting/statistics
% -------------------------------------------------------------------------
sev=info.severity(:);
Tw=table(sev,'VariableNames',{'SeverityPercent'});
for c=1:3
    for ord=0:2
        Tw.([P.ChannelShort{c} '_O' num2str(ord) '_Total']) = ...
            metrics.totalEnergy(:,c,ord+1);
        Tw.([P.ChannelShort{c} '_O' num2str(ord) '_MeanPath']) = ...
            metrics.meanEnergyPerPath(:,c,ord+1);
        Tw.([P.ChannelShort{c} '_O' num2str(ord) '_RelD0']) = ...
            metrics.relativeToD0(:,c,ord+1);
        Tw.([P.ChannelShort{c} '_O' num2str(ord) '_Ratio']) = ...
            metrics.energyRatio(:,c,ord+1);
    end
end
writetable(Tw,fullfile(outDir,'WSCN_OrderEnergy_Strict_Wide.csv'));

% -------------------------------------------------------------------------
% 5) Display scales
% -------------------------------------------------------------------------
Ts=table(P.StageLabels(:),stageScales(:), ...
    'VariableNames',{'Stage','CommonScale_AllChannels_AllStates'});
for c=1:3
    Ts.([P.ChannelShort{c} '_DiagnosticScale'])=channelScales(:,c);
end
writetable(Ts,fullfile(outDir,'WSCN_Stage_Display_Scales.csv'));

% -------------------------------------------------------------------------
% 6) Network info
% -------------------------------------------------------------------------
fid=fopen(fullfile(outDir,'WSCN_Network_Info.txt'),'w');
fprintf(fid,'Input source: %s\n',inputSource);
fprintf(fid,'ImageSize: %d x %d\n',size(data{1},1),size(data{1},2));
fprintf(fid,'InvarianceScale: %g\n',P.WSCN.InvarianceScale);
fprintf(fid,'NumRotations: %s\n',mat2str(P.WSCN.NumRotations));
fprintf(fid,'Path counts: %s\n',mat2str(npaths(:).'));
fprintf(fid,'CAP lag: %d\n',P.CAP.Lag);
fprintf(fid,'CAP delta: %.6g deg\n',P.CAP.DeltaDeg);
fprintf(fid,'CAP psi: %.6g deg\n',P.CAP.PsiDeg);
fprintf(fid,'Display percentile: %.6g\n',P.WSCN.DisplayPercentile);
if ~isempty(capRef)
    fprintf(fid,'CAP fixed reference Ar: %.12g\n',capRef.Ar);
    fprintf(fid,'CAP fixed reference At: %.12g\n',capRef.At);
    fprintf(fid,'CAP fixed reference Az: %.12g\n',capRef.Az);
end
fclose(fid);

save(fullfile(outDir,'WSCN_ProcessMaps_AllStates.mat'), ...
    'maps','metrics','info','P','npaths','stageScales','channelScales', ...
    'inputSource','capRef','-v7.3');
end
