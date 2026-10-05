function C = classifier_default_config()
% Classifier settings.

% Six-class severity diagnosis:
% 0 / 10 / 30 / 50 / 70 / 100 %
C.ExpectedClasses = [0 10 30 50 70 100];

% -------------------------------------------------------------------------
% Synthetic augmentation is used only because the bundled demonstration
% dataset currently contains one independent waveform per severity.
%
% Augmentation does NOT turn one simulation into independent experiments.
% The pipeline therefore marks the current validation as PROTOTYPE.
% -------------------------------------------------------------------------
C.AugmentationsPerSource = 8;  % includes one unmodified sample
C.GainStd = 0.010;             % 1% amplitude jitter
C.MinSNRdB = 38;
C.MaxSNRdB = 46;
C.EnableCircularShift = true;

% Deterministic results.
C.RandomSeed = 20260830;

% PCA.
C.PCAVarianceToKeep = 0.95;
C.MaxPC = 20;
C.MinPC = 2;

% Cross-validation.
C.MaxFolds = 5;

% Reuse extracted WSCN features when source files/config are unchanged.
C.UseFeatureCache = true;

% Feature ranking figure.
C.NumTopFeatures = 15;

% Main model preference if CV accuracies are tied.
C.Preference = { ...
    'svm_rbf', ...
    'svm_linear', ...
    'lda', ...
    'knn', ...
    'nearest_centroid'};
end
