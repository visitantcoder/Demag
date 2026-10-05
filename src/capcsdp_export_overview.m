function capcsdp_export_overview(tensors,info,P,globalScale,channelScales)
% Save white-background CAP-CSDP previews next to the generated tensors.

outDir=fullfile(P.ResultsRoot,'cap_csdp_tensors');
if ~exist(outDir,'dir'), mkdir(outDir); end

style=wscn_style('paper');

fig=capcsdp_plot_rgb_white(tensors,info,P,style,globalScale);
wscn_export_figure(fig,outDir,'CAP_CSDP_AllStates_WHITE_BG',style);
close(fig);

fig=capcsdp_plot_channels_white(tensors,info,P,style,channelScales);
wscn_export_figure(fig,outDir,'CAP_CSDP_Channels_WHITE_BG',style);
close(fig);
end
