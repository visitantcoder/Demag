function fig = wscn_plot_process_rgb(maps,info,P,style,stageScales)
N=numel(info.severity);
K=size(maps,1);

fig=figure('Color','w','Units','inches', ...
    'Position',[0.4 0.4 style.ProcessSize],'Renderer','painters');

L=wscn_layout_begin(fig,K,N);
firstAxes=zeros(K,1);

for k=1:K
    sc=stageScales(k);
    for i=1:N
        ax=wscn_layout_next(L,(k-1)*N+i);
        if i==1, firstAxes(k)=ax; end

        rgb=zeros(size(maps{k,i,1},1),size(maps{k,i,1},2),3);
        for c=1:3
            rgb(:,:,c)=localClip(maps{k,i,c}/sc);
        end

        image(ax,rgb);
        axis(ax,'image');
        axis(ax,'off');

        if k==1
            title(ax,info.label{i}, ...
                'FontName',style.FontName,'FontSize',style.TitleFont, ...
                'FontWeight','bold');
        end
    end
end

drawnow;

% Row labels. Position is derived from the first axis in each row and works
% with both tiledlayout and subplot.
for k=1:K
    pos=get(firstAxes(k),'Position');
    annotation(fig,'textbox',[0.001 pos(2) max(0.048,pos(1)-0.006) pos(4)], ...
        'String',P.StageLabels{k},'EdgeColor','none', ...
        'HorizontalAlignment','right','VerticalAlignment','middle', ...
        'FontName',style.FontName,'FontSize',style.SmallFont, ...
        'FontWeight','bold');
end

if style.ShowSuperTitle
    wscn_super_title(L,'Channel-wise WSCN Process — Common Scale per Stage',style);
end

annotation(fig,'textbox',[0.10 0.001 0.88 0.026], ...
    'String','R: B_r    G: B_t    B: B_z    |    one common display scale per WSCN stage across all states and channels', ...
    'EdgeColor','none','HorizontalAlignment','center', ...
    'VerticalAlignment','middle','FontName',style.FontName, ...
    'FontSize',style.SmallFont);
end

function X=localClip(X)
X=min(max(X,0),1);
end
