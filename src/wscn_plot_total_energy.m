function fig = wscn_plot_total_energy(metrics,info,style)
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

    Y=squeeze(metrics.totalEnergy(:,c,:));
    for o=1:3
        plot(ax,sev,Y(:,o),'-','Marker',markers{o}, ...
            'LineWidth',style.LineWidth,'MarkerSize',style.MarkerSize, ...
            'DisplayName',names{o});
    end

    wscn_format_axes(ax,sev,style);
    try
        ax.YAxis.Exponent=localExponent(Y);
    catch
    end

    title(ax,titles{c},'FontName',style.FontName, ...
        'FontSize',style.TitleFont,'FontWeight','normal');
    text(ax,0.02,0.96,panels{c},'Units','normalized', ...
        'VerticalAlignment','top','FontName',style.FontName, ...
        'FontSize',style.FontSize,'FontWeight','bold');

    xlabel(ax,'Demagnetization severity (%)');
    if c==1, ylabel(ax,'Total-order energy'); end
end

wscn_shared_legend(firstAx,L,style,names);

if style.ShowSuperTitle
    wscn_super_title(L,'WSCN Total-Order Energy',style);
end
end

function e=localExponent(Y)
v=max(abs(Y(:)));
if ~(isfinite(v) && v>0), e=0; return; end
e=3*floor(log10(v)/3);
if e>0, e=0; end
end
