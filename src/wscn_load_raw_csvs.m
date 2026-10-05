function [dataRaw,info] = wscn_load_raw_csvs(P)
% Robust loader for the bundled Dxx.csv files.
%
% Compatible with older MATLAB releases:
%   - does not require VariableNamingRule
%   - does not require contains()
%
% Expected bundled columns are equivalent to:
%   Time [ms]
%   Btan_side []
%   Bradial_side []
%   Baxial_side []
%
% The loader identifies columns by normalized names. If a MATLAB release
% modifies the header names during readtable(), the normalized matching
% still works.

files = dir(fullfile(P.DataDir,'D*.csv'));
if isempty(files)
    error('No Dxx.csv files found in %s',P.DataDir);
end

items = struct('severity',{},'label',{},'file',{}, ...
               'time',{},'Br',{},'Bt',{},'Bz',{});

for k = 1:numel(files)

    tok = regexp(files(k).name,'^D(\d+)\.csv$', ...
                 'tokens','once','ignorecase');
    if isempty(tok)
        continue;
    end

    sev = str2double(tok{1});
    fname = fullfile(files(k).folder,files(k).name);

    % Newer MATLAB: preserve original names.
    % Older MATLAB: fall back to the standard readtable behavior.
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

    % Extra robust fallback for the exact bundled 4-column files.
    % The bundled data order is:
    %   Time, Btan, Bradial, Baxial
    if (isempty(idxBt) || isempty(idxBr) || isempty(idxBz)) && width(T) >= 4
        idxTime = 1;
        idxBt   = 2;
        idxBr   = 3;
        idxBz   = 4;
        fprintf(['  Warning: header-name matching was unavailable for %s.\n', ...
                 '           Falling back to bundled column order: ', ...
                 'Time / Bt / Br / Bz.\n'], files(k).name);
    end

    if isempty(idxBr) || isempty(idxBt) || isempty(idxBz)
        fprintf(2,'\nDetected column names in %s:\n',files(k).name);
        for j = 1:numel(names)
            fprintf(2,'  %d: %s\n',j,names{j});
        end
        error('Could not identify Br/Bt/Bz columns in %s.',fname);
    end

    if isempty(idxTime)
        t = (0:height(T)-1).';
    else
        t = localNumericColumn(T,idxTime,fname);
    end

    Bt = localNumericColumn(T,idxBt,fname);
    Br = localNumericColumn(T,idxBr,fname);
    Bz = localNumericColumn(T,idxBz,fname);

    if any(~isfinite([Br;Bt;Bz]))
        error('NaN/Inf found in %s.',fname);
    end

    items(end+1) = struct( ... %#ok<AGROW>
        'severity',sev, ...
        'label',sprintf('D%d',sev), ...
        'file',fname, ...
        'time',t(:), ...
        'Br',Br(:), ...
        'Bt',Bt(:), ...
        'Bz',Bz(:));
end

if isempty(items)
    error('No valid Dxx.csv data files were loaded from %s.',P.DataDir);
end

[~,ord] = sort([items.severity]);
items = items(ord);

dataRaw = items;
info.severity = [items.severity].';
info.label = {items.label}.';
info.file = {items.file}.';

fprintf('\nLoaded raw CSV states successfully:\n');
for i = 1:numel(items)
    fprintf('  %-5s  N=%d\n',items(i).label,numel(items(i).Br));
end
end


function idx = localFindCol(names,patterns)
% IMPORTANT:
% Convert to lower case BEFORE removing non-alphanumeric characters.
% The previous version removed uppercase B first, so e.g.
% "Btan_side []" became "tanside" and could not match "btan".

idx = [];

for k = 1:numel(names)

    namek = names{k};
    if ~ischar(namek)
        namek = char(namek);
    end

    s = regexprep(lower(namek),'[^a-z0-9]','');

    for p = 1:numel(patterns)
        q = regexprep(lower(patterns{p}),'[^a-z0-9]','');

        % strfind is used instead of contains() for older MATLAB releases.
        if ~isempty(strfind(s,q)) %#ok<STREMP>
            idx = k;
            return;
        end
    end
end
end


function x = localNumericColumn(T,idx,fname)
% Convert a table column robustly to double.

x = T{:,idx};

if isnumeric(x) || islogical(x)
    x = double(x);
elseif iscell(x)
    try
        x = cellfun(@str2double,x);
    catch
        error('Column %d in %s is not numeric.',idx,fname);
    end
else
    try
        x = str2double(x);
    catch
        error('Column %d in %s is not numeric.',idx,fname);
    end
end

x = double(x(:));

if any(isnan(x))
    error('Non-numeric/NaN values detected in column %d of %s.',idx,fname);
end
end
