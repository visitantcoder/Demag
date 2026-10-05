function WSCN_PUBLICATION_PIPELINE(ROOT,mode)
% End-to-end pipeline:
% raw three-axis CSV -> CAP-CSDP -> channel-wise WSCN -> numerical audit ->
% paper/PPT-ready figures.
%
% mode:
%   'AUTO'        : prefer approved tensors if all six exist; otherwise
%                   regenerate CAP-CSDP from bundled CSV files.
%   'TENSOR_ONLY' : require tensors from input_energy_tensors/.

if nargin < 2, mode = 'AUTO'; end
P = wscn_default_config(ROOT);

if ~exist(P.ResultsRoot,'dir')
    mkdir(P.ResultsRoot);
end

[data,info,inputSource,capRef] = wscn_prepare_inputs(P,mode);

imgSize = [size(data{1},1),size(data{1},2)];
for i=2:numel(data)
    if size(data{i},1)~=imgSize(1) || size(data{i},2)~=imgSize(2) || size(data{i},3)~=3
        error('All CAP-CSDP tensors must have the same HxWx3 size.');
    end
end

% -------------------------------------------------------------------------
% CAP-CSDP publication display information.
% This does NOT modify the CAP-CSDP numerical tensor.
% -------------------------------------------------------------------------
[capGlobalScale,capChannelScales] = capcsdp_display_scales(data,P);
capcsdp_save_display_audit(P,capGlobalScale,capChannelScales);

% Save white-background CAP-CSDP previews beside the tensors.
capcsdp_export_overview(data,info,P,capGlobalScale,capChannelScales);

% -------------------------------------------------------------------------
% WSCN
% -------------------------------------------------------------------------
sf = waveletScattering2( ...
    'ImageSize',imgSize, ...
    'InvarianceScale',P.WSCN.InvarianceScale, ...
    'NumRotations',P.WSCN.NumRotations);

[~,npaths] = paths(sf);

fprintf('\nWSCN configuration\n');
fprintf('  input source       : %s\n',inputSource);
fprintf('  image size         : [%d %d]\n',imgSize(1),imgSize(2));
fprintf('  invariance scale   : %g\n',P.WSCN.InvarianceScale);
fprintf('  rotations          : %s\n',mat2str(P.WSCN.NumRotations));
fprintf('  path counts        : %s\n',mat2str(npaths(:).'));

[maps,metrics] = wscn_compute_all(sf,data,info,P);

% Strict WSCN display scale:
% one scale for each stage, shared by D-state AND Br/Bt/Bz.
stageScales = wscn_stage_common_scales(maps,P);

% Diagnostic scale:
% same stage+channel shared only across D-states.
channelScales = wscn_channel_scales(maps,P);

wscn_save_audit(data,maps,metrics,info,P,npaths,stageScales,channelScales,inputSource,capRef);

% -------------------------------------------------------------------------
% Publication/PPT output
% -------------------------------------------------------------------------
for k=1:numel(P.OutputModes)
    outputMode=P.OutputModes{k};
    style=wscn_style(outputMode);
    outDir=fullfile(P.ResultsRoot,'publication',outputMode);
    if ~exist(outDir,'dir'), mkdir(outDir); end

    fprintf('\nExporting %s figures...\n',upper(outputMode));

    % CAP-CSDP is a primary paper result now.
    capcsdp_export_publication_figures( ...
        data,info,P,style,outDir,capGlobalScale,capChannelScales);

    % Original dark-background WSCN process view.
    fig=wscn_plot_process_rgb(maps,info,P,style,stageScales);
    wscn_export_figure(fig,outDir,'WSCN_Process_RGB_AllStates_COMMON_SCALE',style);
    close(fig);

    % Additional print-friendly white-background WSCN view.
    fig=wscn_plot_process_rgb_white(maps,info,P,style,stageScales);
    wscn_export_figure(fig,outDir,'WSCN_Process_RGB_AllStates_WHITE_BG',style);
    close(fig);

    % Single-channel WSCN comparison.
    for c=1:3
        fig=wscn_plot_process_channel(maps,info,c,P,style,stageScales,true);
        wscn_export_figure(fig,outDir, ...
            ['WSCN_Process_' P.ChannelShort{c} '_AllStates_COMMON_SCALE'],style);
        close(fig);

        diagDir=fullfile(outDir,'diagnostic_channel_scale');
        if ~exist(diagDir,'dir'), mkdir(diagDir); end

        fig=wscn_plot_process_channel(maps,info,c,P,style,channelScales(:,c),false);
        wscn_export_figure(fig,diagDir, ...
            ['WSCN_Process_' P.ChannelShort{c} '_CHANNEL_SCALE_DIAGNOSTIC'],style);
        close(fig);
    end

    fig=wscn_plot_total_energy(metrics,info,style);
    wscn_export_figure(fig,outDir,'WSCN_TotalOrderEnergy',style);
    close(fig);

    fig=wscn_plot_relative_energy(metrics,info,style);
    wscn_export_figure(fig,outDir,'WSCN_RelativeToD0',style);
    close(fig);

    fig=wscn_plot_mean_energy(metrics,info,style);
    wscn_export_figure(fig,outDir,'WSCN_MeanEnergyPerPath',style);
    close(fig);

    fig=wscn_plot_energy_ratio(metrics,info,style);
    wscn_export_figure(fig,outDir,'WSCN_TotalOrderEnergyRatio',style);
    close(fig);
end

fprintf('\n============================================================\n');
fprintf('FINISHED.\n');
fprintf('Paper-ready figures:\n  %s\n',fullfile(P.ResultsRoot,'publication','paper'));
fprintf('PPT-ready figures:\n  %s\n',fullfile(P.ResultsRoot,'publication','ppt'));
fprintf('Audit/data:\n  %s\n',fullfile(P.ResultsRoot,'audit'));
fprintf('\nRecommended CAP-CSDP paper figure:\n');
fprintf('  CAP_CSDP_RGB_AllStates_WHITE_BG\n');
fprintf('Detailed CAP-CSDP channel figure:\n');
fprintf('  CAP_CSDP_Channels_AllStates_WHITE_BG\n');
fprintf('============================================================\n\n');
end
