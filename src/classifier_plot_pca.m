function fig = classifier_plot_pca(X,y,C,style,validationMode)
prep=classifier_fit_preprocess(X,C);
Z=classifier_apply_preprocess(X,prep);

if size(Z,2)<2
    Z=[Z zeros(size(Z,1),1)];
end

classes=unique(y(:));
clr=lines(numel(classes));
markers={'o','s','^','d','v','p','h','>','<'};

if strcmpi(style.Mode,'paper')
    figSize=[7.10 4.00];
else
    figSize=[10.8 6.0];
end

fig=figure('Color','w','Units','inches', ...
    'Position',[0.5 0.5 figSize], ...
    'Renderer','painters');

ax=axes('Parent',fig);
hold(ax,'on');

for i=1:numel(classes)
    idx=y==classes(i);
    mk=markers{mod(i-1,numel(markers))+1};

    plot(ax,Z(idx,1),Z(idx,2), ...
        'LineStyle','none', ...
        'Marker',mk, ...
        'MarkerSize',style.MarkerSize+1, ...
        'MarkerFaceColor',clr(i,:), ...
        'MarkerEdgeColor',clr(i,:), ...
        'DisplayName',sprintf('D%d',classes(i)));
end

grid(ax,'on');
box(ax,'on');
ax.GridAlpha=0.18;
set(ax,'FontName',style.FontName,'FontSize',style.FontSize,'TickDir','out');

xlabel(ax,'PC1 score');
ylabel(ax,'PC2 score');

if style.ShowSuperTitle
    title(ax,'PCA of CAP-CSDP/WSCN Features', ...
        'FontName',style.FontName,'FontSize',style.TitleFont, ...
        'FontWeight','normal');
else
    title(ax,'PCA feature space', ...
        'FontName',style.FontName,'FontSize',style.TitleFont, ...
        'FontWeight','normal');
end

legend(ax,'Location','eastoutside','Box','off');

txt=classifier_validation_label(validationMode);
annotation(fig,'textbox',[0.12 0.002 0.76 0.034], ...
    'String',txt, ...
    'Interpreter','none', ...
    'EdgeColor','none','HorizontalAlignment','center', ...
    'FontName',style.FontName,'FontSize',style.SmallFont);
end
