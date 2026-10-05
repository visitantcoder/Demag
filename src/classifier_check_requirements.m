function classifier_check_requirements()
fprintf('\nChecking classifier requirements...\n');

if exist('waveletScattering2','file') ~= 2 && exist('waveletScattering2','class') ~= 8
    error('waveletScattering2 was not found. Wavelet Toolbox is required.');
end

fprintf('  Wavelet Toolbox / waveletScattering2 : OK\n');

if exist('fitcecoc','file')==2 && exist('templateSVM','file')==2
    fprintf('  ECOC-SVM                             : available\n');
else
    fprintf('  ECOC-SVM                             : not available\n');
end

if exist('fitcdiscr','file')==2
    fprintf('  LDA                                  : available\n');
else
    fprintf('  LDA                                  : not available\n');
end

if exist('fitcknn','file')==2
    fprintf('  kNN                                  : available\n');
else
    fprintf('  kNN                                  : not available\n');
end

fprintf('  Nearest centroid                     : available (fallback)\n\n');
end
