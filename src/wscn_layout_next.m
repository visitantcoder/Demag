function ax = wscn_layout_next(L,index)
if L.useTiled
    ax = nexttile(L.obj,index);
else
    figure(L.fig);
    ax = subplot(L.nrow,L.ncol,index);
end
end
