function [data,info,inputSource,capRef] = wscn_prepare_inputs(P,mode)
% Prefer approved CAP-CSDP tensors when a complete set exists.
% Otherwise, AUTO mode regenerates them from the six bundled raw CSVs.

[dataTensor,infoTensor,complete] = wscn_try_load_tensors(P);

if strcmpi(mode,'TENSOR_ONLY')
    if ~complete
        error(['RUN_WSCN_ONLY requires a complete set of D0/D10/D30/D50/D70/D100 ', ...
               'CAP-CSDP tensors in input_energy_tensors/.']);
    end
    data=dataTensor;
    info=infoTensor;
    inputSource='approved CAP-CSDP tensors';
    capRef=[];
    return;
end

if complete
    fprintf('\nComplete tensor set detected. Using input_energy_tensors/.\n');
    data=dataTensor;
    info=infoTensor;
    inputSource='approved CAP-CSDP tensors';
    capRef=[];
    return;
end

fprintf('\nNo complete tensor set detected. Rebuilding CAP-CSDP from bundled CSV data.\n');
[dataRaw,info] = wscn_load_raw_csvs(P);
[data,capRef] = capcsdp_build_all(dataRaw,info,P);
inputSource='bundled raw CSV -> regenerated CAP-CSDP';
end
