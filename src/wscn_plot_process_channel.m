function fig = wscn_plot_process_channel(maps,info,c,P,style,scales,isStrictCommon)
N=numel(info.severity);
K=size(maps,1);

fig=figure('Color','w','Units','inches', ...
    'Position',[0.4 0.4 style.ProcessSize],'Renderer','painters');

L=wscn_layout_begin(fig,K,N);
firstAxes=zeros(K,1);

for k=1:K
    sc=scales(k);
    for i=1:N
        ax=wscn_layout_next(L,(k-1)*N+i);
        if i==1, firstAxes(k)=ax; end

        A=min(max(maps{k,i,c}/sc,0),1);
        imagesc(ax,A,[0 1]);
        axis(ax,'image');
        axis(ax,'off');

        try
            colormap(ax,turbo(256));
        catch
            try
                colormap(ax,parula(256));
            catch
                colormap(ax,jet(256));
            end
        end

        if k==1
            title(ax,info.label{i}, ...
                'FontName',style.FontName,'FontSize',style.TitleFont, ...
                'FontWeight','bold');
        end
    end
end

drawnow;
for k=1:K
    pos=get(firstAxes(k),'Position');
    annotation(fig,'textbox',[0.001 pos(2) max(0.048,pos(1)-0.006) pos(4)], ...
        'String',P.StageLabels{k},'EdgeColor','none', ...
        'HorizontalAlignment','right','VerticalAlignment','middle', ...
        'FontName',style.FontName,'FontSize',style.SmallFont, ...
        'FontWeight','bold');
end

if style.ShowSuperTitle
    wscn_super_title(L,['WSCN Process — ' P.ChannelLong{c}],style);
end

if isStrictCommon
    note='Strict common scale: same stage scale used for B_r, B_t, B_z and all D-states';
else
    note='Diagnostic channel scale: morphology only; do not compare absolute brightness across channels';
end

annotation(fig,'textbox',[0.10 0.001 0.88 0.026], ...
    'String',note,'EdgeColor','none','HorizontalAlignment','center', ...
    'VerticalAlignment','middle','FontName',style.FontName, ...
    'FontSize',style.SmallFont);
end
