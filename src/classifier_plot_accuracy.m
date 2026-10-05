function fig = classifier_plot_accuracy(results,style)
valid=find([results.ok]);

names=cell(numel(valid),1);
acc=zeros(numel(valid),1);
f1=zeros(numel(valid),1);

for i=1:numel(valid)
    names{i}=results(valid(i)).display;
    acc(i)=100*results(valid(i)).metrics.accuracy;
    f1(i)=100*results(valid(i)).metrics.macroF1;
end

if strcmpi(style.Mode,'paper')
    figSize=[7.10 3.65];
else
    figSize=[11.5 5.7];
end

fig=figure('Color','w','Units','inches', ...
    'Position',[0.5 0.5 figSize], ...
    'Renderer','painters');

ax=axes('Parent',fig);
bar(ax,[acc f1]);

grid(ax,'on');
box(ax,'on');
ax.GridAlpha=0.18;

set(ax,'XTick',1:numel(valid), ...
    'XTickLabel',names, ...
    'FontName',style.FontName, ...
    'FontSize',style.SmallFont, ...
    'TickDir','out');

try
    ax.XAxis.TickLabelInterpreter='none';
catch
end

try
    xtickangle(ax,15);
catch
end

ylabel(ax,'Cross-validation score (%)');
ylim(ax,[0 105]);

legend(ax,{'Accuracy','Macro F1'}, ...
    'Location','northoutside', ...
    'Orientation','horizontal', ...
    'Box','off');

if style.ShowSuperTitle
    title(ax,'Classifier Comparison', ...
        'FontName',style.FontName,'FontSize',style.TitleFont, ...
        'FontWeight','normal');
else
    title(ax,'Classifier comparison', ...
        'FontName',style.FontName,'FontSize',style.TitleFont, ...
        'FontWeight','normal');
end

for i=1:numel(valid)
    text(ax,i-0.15,acc(i)+1.4,sprintf('%.1f',acc(i)), ...
        'HorizontalAlignment','center', ...
        'FontName',style.FontName,'FontSize',style.SmallFont);

    text(ax,i+0.15,f1(i)+1.4,sprintf('%.1f',f1(i)), ...
        'HorizontalAlignment','center', ...
        'FontName',style.FontName,'FontSize',style.SmallFont);
end
end
