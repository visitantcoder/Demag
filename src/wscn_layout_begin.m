function L = wscn_layout_begin(fig,nrow,ncol)
% Compatibility layout wrapper.
L.fig = fig;
L.nrow = nrow;
L.ncol = ncol;
L.useTiled = wscn_has_tiledlayout();

if L.useTiled
    L.obj = tiledlayout(fig,nrow,ncol,'TileSpacing','compact','Padding','compact');
else
    L.obj = [];
end
end
