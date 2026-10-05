function capcsdp_export_publication_figures(tensors,info,P,style,outDir,globalScale,channelScales)
% Export CAP-CSDP figures directly into the publication folders.

fig=capcsdp_plot_rgb_white(tensors,info,P,style,globalScale);
wscn_export_figure(fig,outDir,'CAP_CSDP_RGB_AllStates_WHITE_BG',style);
close(fig);

fig=capcsdp_plot_channels_white(tensors,info,P,style,channelScales);
wscn_export_figure(fig,outDir,'CAP_CSDP_Channels_AllStates_WHITE_BG',style);
close(fig);
end
