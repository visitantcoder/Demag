function fig = wscn_plot_energy_ratio(metrics,info,style)
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

    Y=squeeze(metrics.energyRatio(:,c,:));
    for o=1:3
        plot(ax,sev,Y(:,o),'-','Marker',markers{o}, ...
            'LineWidth',style.LineWidth,'MarkerSize',style.MarkerSize, ...
            'DisplayName',names{o});
    end

    wscn_format_axes(ax,sev,style);
    ylim(ax,[0 1]);
    title(ax,titles{c},'FontName',style.FontName, ...
        'FontSize',style.TitleFont,'FontWeight','normal');
    text(ax,0.02,0.96,panels{c},'Units','normalized', ...
        'VerticalAlignment','top','FontName',style.FontName, ...
        'FontSize',style.FontSize,'FontWeight','bold');

    xlabel(ax,'Demagnetization severity (%)');
    if c==1, ylabel(ax,'Fraction of total scattering energy'); end
end

wscn_shared_legend(firstAx,L,style,names);

if style.ShowSuperTitle
    wscn_super_title(L,'WSCN Scattering-Order Energy Ratio',style);
end
end
