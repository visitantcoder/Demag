function out = classifier_pretty_feature_name(name)
% Convert internal feature identifiers into publication-friendly labels.

out = strrep(name,'_',' ');

% Physical channels.
out = strrep(out,'Br','B_r');
out = strrep(out,'Bt','B_t');
out = strrep(out,'Bz','B_z');

% CAP names.
out = strrep(out,'CAP Mean','CAP mean');
out = strrep(out,'CAP Std','CAP standard deviation');
out = strrep(out,'CAP RMS','CAP RMS');
out = strrep(out,'CAP Max','CAP maximum');
out = strrep(out,'CAP ActiveFrac','CAP active-pixel fraction');

% Order names.
out = regexprep(out,'O0 ','Order 0 ');
out = regexprep(out,'O1 ','Order 1 ');
out = regexprep(out,'O2 ','Order 2 ');

% WSCN feature names.
out = strrep(out,'TotalE','total energy');
out = strrep(out,'MeanPathE','mean path energy');
out = strrep(out,'StdPathE','path-energy standard deviation');
out = strrep(out,'MaxPathE','maximum path energy');
out = strrep(out,'PathEntropy','path-energy entropy');
out = strrep(out,'Top10Frac','top-10% energy fraction');

% Ratio names.
out = strrep(out,'over','/');
out = strrep(out,' energy ratio',' ratio');
end
