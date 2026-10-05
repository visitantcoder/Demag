function fig = capcsdp_plot_channels_white(tensors,info,P,style,channelScales)
% Detailed CAP-CSDP channel figure:
% rows = Br/Bt/Bz
% columns = D-states
%
% Each ROW uses one fixed scale across all D-states.  This makes weak
% channel morphology legible.  Brightness between different rows must NOT
% be interpreted as an absolute cross-channel amplitude comparison.

N=numel(tensors);
C=3;

fig=figure('Color','w','Units','inches', ...
    'Position',[0.4 0.4 style.CAPChannelSize], ...
    'Renderer','painters');

L=wscn_layout_begin(fig,C,N);
firstAxes=cell(C,1);

rowColors={P.CAP.BrColor,P.CAP.BtColor,P.CAP.BzColor};

for c=1:C
    for i=1:N
        idx=(c-1)*N+i;
        ax=wscn_layout_next(L,idx);

        if i==1
            firstAxes{c}=ax;
        end

        RGB=capcsdp_white_channel( ...
            tensors{i}(:,:,c), ...
            channelScales(c), ...
            P.CAP.DisplayGamma, ...
            rowColors{c});

        image(ax,RGB);
        axis(ax,'image');
        axis(ax,'off');

        if c==1
            title(ax,info.label{i}, ...
                'FontName',style.FontName, ...
                'FontSize',style.TitleFont, ...
                'FontWeight','bold');
        end
    end
end

drawnow;

% Row labels. For older MATLAB the axes handles are converted back with
% handle() only where needed; annotation itself is version-friendly.
for c=1:C
    axh=firstAxes{c};
    pos=get(axh,'Position');

    annotation(fig,'textbox', ...
        [0.001 pos(2) max(0.045,pos(1)-0.006) pos(4)], ...
        'String',P.ChannelShort{c}, ...
        'EdgeColor','none', ...
        'HorizontalAlignment','right', ...
        'VerticalAlignment','middle', ...
        'FontName',style.FontName, ...
        'FontSize',style.TitleFont, ...
        'FontWeight','bold');
end

if style.ShowSuperTitle
    wscn_super_title(L, ...
        'CAP-CSDP Physical-Channel Decomposition',style);
end

annotation(fig,'textbox',[0.10 0.002 0.88 0.027], ...
    'String','White = zero response; common display scale within each row across D-states (row scales are independent)', ...
    'EdgeColor','none', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontName',style.FontName, ...
    'FontSize',style.SmallFont);
end
