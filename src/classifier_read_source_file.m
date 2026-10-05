function src = classifier_read_source_file(fname,sourceID)
% Read one Time/Bt/Br/Bz CSV file with old-MATLAB-compatible header logic.

try
    T = readtable(fname,'VariableNamingRule','preserve');
catch
    T = readtable(fname);
end

names = T.Properties.VariableNames;

idxTime = localFindCol(names,{'time'});
idxBt   = localFindCol(names,{'btanside','btan','btangential','tangential'});
idxBr   = localFindCol(names,{'bradialside','bradial','radial'});
idxBz   = localFindCol(names,{'baxialside','baxial','axial','bz'});

% Safe fallback for the bundled four-column files:
% Time / Bt / Br / Bz.
if (isempty(idxBt) || isempty(idxBr) || isempty(idxBz)) && width(T)>=4
    idxTime=1; idxBt=2; idxBr=3; idxBz=4;
end

if isempty(idxBt) || isempty(idxBr) || isempty(idxBz)
    error('Could not identify Time/Bt/Br/Bz columns in %s.',fname);
end

if isempty(idxTime)
    t=(0:height(T)-1).';
else
    t=localNumeric(T,idxTime,fname);
end

Bt=localNumeric(T,idxBt,fname);
Br=localNumeric(T,idxBr,fname);
Bz=localNumeric(T,idxBz,fname);

if any(~isfinite([Br;Bt;Bz]))
    error('NaN/Inf found in %s.',fname);
end

src.severity=NaN;
src.label='';
src.file=fname;
[~,nm,ext]=fileparts(fname);
src.name=[nm ext];
src.sourceID=sourceID;
src.time=t(:);
src.Br=Br(:);
src.Bt=Bt(:);
src.Bz=Bz(:);
end

function idx=localFindCol(names,patterns)
idx=[];
for k=1:numel(names)
    s=regexprep(lower(char(names{k})),'[^a-z0-9]','');
    for p=1:numel(patterns)
        q=regexprep(lower(patterns{p}),'[^a-z0-9]','');
        if ~isempty(strfind(s,q)) %#ok<STREMP>
            idx=k;
            return;
        end
    end
end
end

function x=localNumeric(T,idx,fname)
x=T{:,idx};
if isnumeric(x) || islogical(x)
    x=double(x);
elseif iscell(x)
    x=cellfun(@str2double,x);
else
    x=str2double(x);
end
x=double(x(:));
if any(isnan(x))
    error('Non-numeric values found in column %d of %s.',idx,fname);
end
end
