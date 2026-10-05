function wscn_format_axes(ax,sev,style)
grid(ax,'on'); box(ax,'on');
ax.GridAlpha=0.18;
ax.MinorGridAlpha=0.08;
ax.FontName=style.FontName;
ax.FontSize=style.FontSize;
ax.LineWidth=style.AxesLineWidth;
ax.TickDir='out';
ax.XTick=sev(:).';
xlim(ax,[min(sev) max(sev)]);
end
