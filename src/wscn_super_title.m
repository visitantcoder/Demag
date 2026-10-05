function wscn_super_title(L,str,style)
% Compatible super-title. Uses sgtitle when available; otherwise annotation.
if exist('sgtitle','file') == 2
    try
        if L.useTiled
            sgtitle(L.obj,str,'FontName',style.FontName, ...
                'FontSize',style.TitleFont,'FontWeight','normal');
        else
            sgtitle(L.fig,str,'FontName',style.FontName, ...
                'FontSize',style.TitleFont,'FontWeight','normal');
        end
        return;
    catch
    end
end

annotation(L.fig,'textbox',[0.05 0.965 0.90 0.03], ...
    'String',str,'EdgeColor','none', ...
    'HorizontalAlignment','center','VerticalAlignment','middle', ...
    'FontName',style.FontName,'FontSize',style.TitleFont, ...
    'FontWeight','normal');
end
