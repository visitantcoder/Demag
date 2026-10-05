function wscn_shared_legend(ax,L,style,names)
% Use tiled-layout shared legend when possible.
lgd=legend(ax,names,'Orientation','horizontal','Box','off', ...
    'FontName',style.FontName,'FontSize',style.SmallFont);

if L.useTiled
    try
        lgd.Layout.Tile='south';
        return;
    catch
    end
end

% Compatibility mode: put legend below the middle plot area if supported.
try
    set(lgd,'Location','southoutside');
catch
    set(lgd,'Location','SouthOutside');
end
end
