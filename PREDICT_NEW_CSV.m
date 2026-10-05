function predictedSeverity = PREDICT_NEW_CSV(csvFile)
% PREDICT_NEW_CSV  Predict demagnetization severity for one new CSV file.
%
% Examples:
%   PREDICT_NEW_CSV
%   PREDICT_NEW_CSV('my_new_measurement.csv')
%
% The CSV is expected to contain:
%   Time, Bt, Br, Bz
% with names equivalent to the bundled files.
%
% A trained model must already exist. Run RUN_CLASSIFIER first.

ROOT = fileparts(mfilename('fullpath'));
addpath(fullfile(ROOT,'src'));

modelFile = fullfile(ROOT,'results','classifier','model', ...
    'WSCN_Classifier_FinalModel.mat');

if exist(modelFile,'file') ~= 2
    error('Classifier model not found. Run RUN_CLASSIFIER first.');
end

if nargin < 1 || isempty(csvFile)
    [f,p] = uigetfile('*.csv','Select a new Br/Bt/Bz CSV file');
    if isequal(f,0)
        predictedSeverity = [];
        return;
    end
    csvFile = fullfile(p,f);
end

S = load(modelFile,'bundle');
bundle = S.bundle;

source = classifier_read_source_file(csvFile,0);
tensor = classifier_build_cap_tensor(source,bundle.capRef,bundle.P);

sf = waveletScattering2( ...
    'ImageSize',[size(tensor,1) size(tensor,2)], ...
    'InvarianceScale',bundle.P.WSCN.InvarianceScale, ...
    'NumRotations',bundle.P.WSCN.NumRotations);

[fvec,~] = classifier_extract_features(sf,tensor,bundle.P);
Z = classifier_apply_preprocess(fvec,bundle.preprocess);
predictedSeverity = classifier_predict_model(bundle.model,Z,bundle.classifierName);

fprintf('\nPredicted demagnetization severity: D%d\n',predictedSeverity);
fprintf('Classifier: %s\n\n',bundle.classifierDisplayName);
end
