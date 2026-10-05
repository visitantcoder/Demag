function fig = wscn_plot_relative_energy(metrics,info,style)
fig=wscn_energy_figure(style);
L=wscn_layout_begin(fig,1,3);

sev=info.severity(:);
names={'Order 0','Order 1','Order 2'};
titles={'Radial, B_r','Tangential, B_t','Axial, B_z'};
panels={'(a)','(b)','(c)'};
markers={'o','s','^'};
firstAx=[];

for c=1:3
    ax=wscn_layout_next(L,c); hold(ax,'on');
    if c==1, firstAx=ax; end

    Y=squeeze(metrics.relativeToD0(:,c,:));
    for o=1:3
        plot(ax,sev,Y(:,o),'-','Marker',markers{o}, ...
            'LineWidth',style.LineWidth,'MarkerSize',style.MarkerSize, ...
            'DisplayName',names{o});
    end

    wscn_format_axes(ax,sev,style);
    wscn_baseline(ax,1,'--','Color',[0.42 0.42 0.42], ...
        'LineWidth',max(0.8,style.LineWidth*0.72), ...
        'HandleVisibility','off');

    title(ax,titles{c},'FontName',style.FontName, ...
        'FontSize',style.TitleFont,'FontWeight','normal');
    text(ax,0.02,0.96,panels{c},'Units','normalized', ...
        'VerticalAlignment','top','FontName',style.FontName, ...
        'FontSize',style.FontSize,'FontWeight','bold');

    xlabel(ax,'Demagnetization severity (%)');
    if c==1, ylabel(ax,'Energy gain relative to D0'); end

    yl=ylim(ax);
    text(ax,sev(end),1+0.02*(yl(2)-yl(1)),'D0 baseline', ...
        'HorizontalAlignment','right','VerticalAlignment','bottom', ...
        'FontName',style.FontName,'FontSize',style.SmallFont, ...
        'Color',[0.35 0.35 0.35]);
end

wscn_shared_legend(firstAx,L,style,names);

if style.ShowSuperTitle
    wscn_super_title(L,'WSCN Relative Energy Evolution vs D0',style);
end
end
