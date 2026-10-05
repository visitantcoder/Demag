function wscn_export_figure(fig,outDir,baseName,style)
% Export a publication/PPT figure in multiple useful formats.

if ~exist(outDir,'dir'), mkdir(outDir); end

pngFile=fullfile(outDir,[baseName '.png']);
tifFile=fullfile(outDir,[baseName '.tif']);
pdfFile=fullfile(outDir,[baseName '.pdf']);
figFile=fullfile(outDir,[baseName '.fig']);
svgFile=fullfile(outDir,[baseName '.svg']);

set(fig,'Color','w');

if exist('exportgraphics','file')==2
    exportgraphics(fig,pngFile,'Resolution',style.PNGResolution);
    try, exportgraphics(fig,tifFile,'Resolution',style.PNGResolution); catch, end
else
    print(fig,pngFile,'-dpng',['-r' num2str(style.PNGResolution)]);
    try, print(fig,tifFile,'-dtiff',['-r' num2str(style.PNGResolution)]); catch, end
end

try
    if exist('exportgraphics','file')==2
        exportgraphics(fig,pdfFile,'ContentType','vector');
    else
        print(fig,pdfFile,'-dpdf','-painters');
    end
catch
    try, print(fig,pdfFile,'-dpdf'); catch, end
end

try, savefig(fig,figFile); catch, end

try
    if exist('exportgraphics','file')==2
        exportgraphics(fig,svgFile,'ContentType','vector');
    else
        print(fig,svgFile,'-dsvg');
    end
catch
end
end
