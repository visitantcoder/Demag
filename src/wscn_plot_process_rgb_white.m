function fig = wscn_plot_process_rgb_white(maps,info,P,style,stageScales)
% Optional white-background WSCN process rendering for print/PPT.
%
% IMPORTANT:
% The underlying WSCN maps remain zero-background numerical arrays.
% Only this exported figure maps zero response to white.

N=numel(info.severity);
K=size(maps,1);

fig=figure('Color','w','Units','inches', ...
    'Position',[0.4 0.4 style.ProcessSize], ...
    'Renderer','painters');

L=wscn_layout_begin(fig,K,N);
firstAxes=cell(K,1);

for k=1:K
    sc=stageScales(k);

    for i=1:N
        idx=(k-1)*N+i;
        ax=wscn_layout_next(L,idx);

        if i==1
            firstAxes{k}=ax;
        end

        E=zeros([size(maps{k,i,1}) 3]);
        for c=1:3
            E(:,:,c)=maps{k,i,c};
        end

        RGB=capcsdp_white_rgb(E,sc,P.CAP.DisplayGamma);

        image(ax,RGB);
        axis(ax,'image');
        axis(ax,'off');

        if k==1
            title(ax,info.label{i}, ...
                'FontName',style.FontName, ...
                'FontSize',style.TitleFont, ...
                'FontWeight','bold');
        end
    end
end

drawnow;

for k=1:K
    pos=get(firstAxes{k},'Position');

    annotation(fig,'textbox', ...
        [0.001 pos(2) max(0.050,pos(1)-0.006) pos(4)], ...
        'String',P.StageLabels{k}, ...
        'EdgeColor','none', ...
        'HorizontalAlignment','right', ...
        'VerticalAlignment','middle', ...
        'FontName',style.FontName, ...
        'FontSize',style.SmallFont, ...
        'FontWeight','bold');
end

if style.ShowSuperTitle
    wscn_super_title(L, ...
        'Channel-wise WSCN Process — White-Background Print View',style);
end

annotation(fig,'textbox',[0.10 0.001 0.88 0.026], ...
    'String','R: B_r    G: B_t    B: B_z    |    white = zero response    |    common scale per WSCN stage', ...
    'EdgeColor','none', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontName',style.FontName, ...
    'FontSize',style.SmallFont);
end
