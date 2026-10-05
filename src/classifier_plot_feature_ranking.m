function fig = classifier_plot_feature_ranking(X,y,featureNames,C,style)
score=classifier_feature_scores(X,y);
[scoreSorted,ord]=sort(score,'descend');

n=min(C.NumTopFeatures,numel(ord));
ord=ord(1:n);
scoreSorted=scoreSorted(1:n);

labels=cell(n,1);
for i=1:n
    labels{i}=classifier_pretty_feature_name(featureNames{ord(i)});
end

if strcmpi(style.Mode,'paper')
    figSize=[7.10 5.45];
else
    figSize=[11.5 7.0];
end

fig=figure('Color','w','Units','inches', ...
    'Position',[0.5 0.5 figSize], ...
    'Renderer','painters');

ax=axes('Parent',fig);
barh(ax,1:n,scoreSorted);

set(ax,'YDir','reverse', ...
    'YTick',1:n, ...
    'YTickLabel',labels, ...
    'FontName',style.FontName, ...
    'FontSize',style.SmallFont, ...
    'TickDir','out');

% Prevent underscores/subscripts and keep the labels literal.
try
    ax.YAxis.TickLabelInterpreter='none';
catch
end

grid(ax,'on');
box(ax,'on');
ax.GridAlpha=0.18;

xlabel(ax,'Between-class / within-class variance score');

if style.ShowSuperTitle
    title(ax,'Most Discriminative CAP-CSDP/WSCN Features', ...
        'FontName',style.FontName, ...
        'FontSize',style.TitleFont, ...
        'FontWeight','normal');
else
    title(ax,'Top diagnostic features', ...
        'FontName',style.FontName, ...
        'FontSize',style.TitleFont, ...
        'FontWeight','normal');
end
end
