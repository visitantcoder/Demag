function h = wscn_baseline(ax,y,varargin)
% yline-compatible horizontal reference line.
if exist('yline','file') == 2
    h = yline(ax,y,varargin{:});
else
    xl = xlim(ax);
    h = plot(ax,xl,[y y],varargin{:});
end
end
