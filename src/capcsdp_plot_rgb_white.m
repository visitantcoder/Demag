function fig = capcsdp_plot_rgb_white(tensors,info,P,style,globalScale)
% Main CAP-CSDP result figure for the paper.
% 2 x 3 states, white background, one strict common scale.

N=numel(tensors);
ncol=3;
nrow=ceil(N/ncol);

fig=figure('Color','w','Units','inches', ...
    'Position',[0.4 0.4 style.CAPRGBSize], ...
    'Renderer','painters');

L=wscn_layout_begin(fig,nrow,ncol);

letters='abcdefghijklmnopqrstuvwxyz';

for i=1:N
    ax=wscn_layout_next(L,i);

    RGB=capcsdp_white_rgb(tensors{i},globalScale,P.CAP.DisplayGamma);
    image(ax,RGB);
    axis(ax,'image');
    axis(ax,'off');

    if i<=numel(letters)
        ttl=sprintf('(%c) %s',letters(i),info.label{i});
    else
        ttl=info.label{i};
    end

    title(ax,ttl, ...
        'FontName',style.FontName, ...
        'FontSize',style.TitleFont, ...
        'FontWeight','normal');
end

if style.ShowSuperTitle
    wscn_super_title(L, ...
        'CAP-CSDP Evolution under Demagnetization',style);
end

annotation(fig,'textbox',[0.10 0.002 0.88 0.027], ...
    'String','R: B_r    G: B_t    B: B_z    |    white = zero response    |    one common display scale for all states/channels', ...
    'EdgeColor','none', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontName',style.FontName, ...
    'FontSize',style.SmallFont);
end
