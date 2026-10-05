function fig = classifier_plot_confusion(M,classes,style,titleText)
C=M.confusion;
rowSum=sum(C,2);
Cn=zeros(size(C));

for i=1:size(C,1)
    if rowSum(i)>0
        Cn(i,:)=C(i,:)/rowSum(i);
    end
end

if strcmpi(style.Mode,'paper')
    figSize=[6.30 5.05];
else
    figSize=[8.5 7.0];
end

fig=figure('Color','w','Units','inches', ...
    'Position',[0.5 0.5 figSize], ...
    'Renderer','painters');

ax=axes('Parent',fig);
imagesc(ax,Cn,[0 1]);
axis(ax,'square');
box(ax,'on');

try
    colormap(fig,parula(256));
catch
    colormap(parula(256));
end

cb=colorbar;
ylabel(cb,'Row-normalized fraction', ...
    'FontName',style.FontName,'FontSize',style.FontSize);

labels=cell(numel(classes),1);
for i=1:numel(classes)
    labels{i}=sprintf('D%d',classes(i));
end

set(ax,'XTick',1:numel(classes),'XTickLabel',labels, ...
       'YTick',1:numel(classes),'YTickLabel',labels, ...
       'FontName',style.FontName,'FontSize',style.FontSize, ...
       'TickDir','out');

xlabel(ax,'Predicted class');
ylabel(ax,'True class');
title(ax,titleText,'Interpreter','none', ...
    'FontName',style.FontName, ...
    'FontSize',style.TitleFont, ...
    'FontWeight','normal');

for i=1:size(Cn,1)
    for j=1:size(Cn,2)
        v=Cn(i,j);

        if v>0.55
            tc=[1 1 1];
        else
            tc=[0 0 0];
        end

        text(ax,j,i,sprintf('%.0f%%\n(n=%d)',100*v,C(i,j)), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontName',style.FontName, ...
            'FontSize',style.SmallFont, ...
            'Color',tc);
    end
end
end
