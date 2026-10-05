function capcsdp_save_display_audit(P,globalScale,channelScales)
outDir=fullfile(P.ResultsRoot,'audit');
if ~exist(outDir,'dir'), mkdir(outDir); end

fid=fopen(fullfile(outDir,'CAP_CSDP_Display_Info.txt'),'w');
fprintf(fid,'CAP-CSDP publication display only\n');
fprintf(fid,'--------------------------------\n');
fprintf(fid,'Numerical tensor background remains 0.\n');
fprintf(fid,'Exported white-background figures map zero response to white.\n');
fprintf(fid,'Display percentile: %.6g\n',P.CAP.DisplayPercentile);
fprintf(fid,'Display gamma: %.6g\n',P.CAP.DisplayGamma);
fprintf(fid,'Strict RGB global scale: %.12g\n',globalScale);
fprintf(fid,'Br row scale: %.12g\n',channelScales(1));
fprintf(fid,'Bt row scale: %.12g\n',channelScales(2));
fprintf(fid,'Bz row scale: %.12g\n',channelScales(3));
fprintf(fid,'\nInterpretation:\n');
fprintf(fid,'CAP_CSDP_RGB_AllStates_WHITE_BG uses one common scale across all states/channels.\n');
fprintf(fid,'CAP_CSDP_Channels_AllStates_WHITE_BG uses one common scale within each row only.\n');
fclose(fid);
end
