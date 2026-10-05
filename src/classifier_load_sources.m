function sources = classifier_load_sources(P)
files = dir(fullfile(P.DataDir,'D*.csv'));

if isempty(files)
    error('No Dxx*.csv files were found in %s.',P.DataDir);
end

sources = struct('severity',{},'label',{},'file',{},'name',{}, ...
                 'sourceID',{},'time',{},'Br',{},'Bt',{},'Bz',{});

sid = 0;

for k=1:numel(files)
    tok = regexp(files(k).name,'^D(\d+).*\.csv$', ...
                 'tokens','once','ignorecase');
    if isempty(tok)
        continue;
    end

    sev = str2double(tok{1});
    sid = sid + 1;

    src = classifier_read_source_file( ...
        fullfile(files(k).folder,files(k).name),sid);

    src.severity = sev;
    src.label = sprintf('D%d',sev);
    src.name = files(k).name;

    sources(end+1) = src; %#ok<AGROW>
end

if isempty(sources)
    error('No valid Dxx*.csv files could be loaded.');
end

% Sort by severity and then filename.
sev = [sources.severity].';
names = {sources.name}.';
[~,nameOrd] = sort(names);
sources = sources(nameOrd);
sev = [sources.severity].';
[~,sevOrd] = sort(sev);
sources = sources(sevOrd);

% Reassign stable source IDs after sorting.
for k=1:numel(sources)
    sources(k).sourceID = k;
end

fprintf('\nIndependent CSV sources detected:\n');
classes = unique([sources.severity]);

for c=1:numel(classes)
    idx = find([sources.severity]==classes(c));
    fprintf('  D%-3d : %d source file(s)\n',classes(c),numel(idx));
    for j=1:numel(idx)
        fprintf('          %s\n',sources(idx(j)).name);
    end
end
end
