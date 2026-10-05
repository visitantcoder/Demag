function P = wscn_default_config(ROOT)
% Central configuration. Normally you do not need to edit anything.

P.Root = ROOT;
P.DataDir = fullfile(ROOT,'data');
P.TensorDir = fullfile(ROOT,'input_energy_tensors');
P.ResultsRoot = fullfile(ROOT,'results');

% -------------------------------------------------------------------------
% CAP-CSDP: final parameters.
% -------------------------------------------------------------------------
P.CAP.ImageSize = 256;
P.CAP.Lag = 10;
P.CAP.DeltaDeg = 50;
P.CAP.PsiDeg = 60;

% Channel-wise fixed references across all supplied D-states.
P.CAP.ReferenceMargin = 1.05;

% Numerical rendering constants.
% IMPORTANT: there is NO per-state max normalization.
P.CAP.BlurSigmaPx = 1.0;
P.CAP.RenderGain = 1.20;
P.CAP.AccumulatorDivisor = 4.0;

% -------------------------------------------------------------------------
% CAP-CSDP publication DISPLAY only.
%
% The numerical CAP-CSDP tensor is NOT inverted and its zero background
% remains exactly zero.  Only the exported figure maps zero response to
% white so it is readable in papers and PowerPoint.
% -------------------------------------------------------------------------
P.CAP.DisplayPercentile = 99.7;

% < 1 makes weak curves easier to see on a white page.
% This is visualization gamma only; it never enters WSCN or energy metrics.
P.CAP.DisplayGamma = 0.58;

% Physical colors used for single-channel paper figures.
P.CAP.BrColor = [0.85 0.10 0.10];
P.CAP.BtColor = [0.00 0.55 0.15];
P.CAP.BzColor = [0.10 0.30 0.85];

% -------------------------------------------------------------------------
% WSCN
% -------------------------------------------------------------------------
P.WSCN.InvarianceScale = 128;
P.WSCN.NumRotations = [6 6];
P.WSCN.DisplaySize = [256 256];

% Robust display scale (visualization only, never used in energy metrics).
P.WSCN.DisplayPercentile = 99.7;

P.ChannelShort = {'Br','Bt','Bz'};
P.ChannelLong = {'Radial, B_r','Tangential, B_t','Axial, B_z'};

P.StageLabels = { ...
    'Input', ...
    'S_0', ...
    'U_1', ...
    'S_1', ...
    'U_2', ...
    'S_2'};

P.OutputModes = {'paper','ppt'};
end
