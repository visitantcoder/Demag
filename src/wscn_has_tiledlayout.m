function tf = wscn_has_tiledlayout()
tf = exist('tiledlayout','file') == 2 && exist('nexttile','file') == 2;
end
