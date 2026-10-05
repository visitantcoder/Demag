function [data,info,complete] = wscn_try_load_tensors(P)
expected=[0 10 30 50 70 100];
data={};
info=struct('severity',[],'label',{{}},'file',{{}});
complete=false;

if ~exist(P.TensorDir,'dir'), return; end
ff=dir(fullfile(P.TensorDir,'*.mat'));
if isempty(ff), return; end

items=struct('severity',{},'file',{},'varname',{});

for k=1:numel(ff)
    tok=regexp(ff(k).name,'D(\d+)','tokens','once','ignorecase');
    if isempty(tok), continue; end
    sev=str2double(tok{1});
    vars=whos('-file',fullfile(ff(k).folder,ff(k).name));
    [ok,varname]=localTensorVar(vars);
    if ok
        items(end+1)=struct('severity',sev, ... %#ok<AGROW>
            'file',fullfile(ff(k).folder,ff(k).name),'varname',varname);
    end
end

if isempty(items), return; end

sevs=[items.severity];
if ~all(ismember(expected,sevs)), return; end

data=cell(numel(expected),1);
info.severity=expected(:);
info.label=cell(numel(expected),1);
info.file=cell(numel(expected),1);

for i=1:numel(expected)
    idx=find(sevs==expected(i),1);
    S=load(items(idx).file,items(idx).varname);
    X=double(S.(items(idx).varname));
    if ndims(X)~=3 || size(X,3)~=3 || any(~isfinite(X(:)))
        error('Invalid HxWx3 tensor: %s',items(idx).file);
    end
    data{i}=X;
    info.label{i}=sprintf('D%d',expected(i));
    info.file{i}=items(idx).file;
end

complete=true;
end

function [ok,varname]=localTensorVar(vars)
ok=false; varname='';
priority={'CAP_CSDP_energy_tensor','CAP_CSDP_tensor','energyTensor','tensor'};
names={vars.name};

for p=1:numel(priority)
    idx=find(strcmp(names,priority{p}),1);
    if ~isempty(idx) && localGood(vars(idx))
        ok=true; varname=vars(idx).name; return;
    end
end

for k=1:numel(vars)
    if localGood(vars(k))
        ok=true; varname=vars(k).name; return;
    end
end
end

function tf=localGood(v)
sz=v.size;
tf=numel(sz)==3 && sz(3)==3 && any(strcmp(v.class, ...
    {'double','single','uint8','uint16','uint32','uint64','int8','int16','int32','int64'}));
end
