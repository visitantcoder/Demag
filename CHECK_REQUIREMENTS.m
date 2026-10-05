%% CHECK_REQUIREMENTS
fprintf('\nChecking MATLAB requirements...\n');

if exist('waveletScattering2','file') ~= 2 && exist('waveletScattering2','class') ~= 8
    error(['waveletScattering2 was not found. ', ...
        'Please install/enable MATLAB Wavelet Toolbox.']);
end

if exist('subplot','file') ~= 2
    error('subplot was not found. MATLAB graphics support is required.');
end

try
    sf_test = waveletScattering2( ...
        'ImageSize',[64 64], ...
        'InvarianceScale',32, ...
        'NumRotations',[4 4]);

    x_test = zeros(64,64);
    x_test(24:40,24:40) = 1;

    [S_test,U_test] = scatteringTransform(sf_test,x_test); %#ok<ASGLU>
    [~,npaths_test] = paths(sf_test);

    fprintf('  waveletScattering2             : OK\n');
    fprintf('  scatteringTransform            : OK\n');
    fprintf('  paths(sf)                      : OK\n');

    if exist('tiledlayout','file') == 2
        fprintf('  tiledlayout                    : available\n');
    else
        fprintf('  tiledlayout                    : not available -> subplot compatibility mode\n');
    end

    if exist('exportgraphics','file') == 2
        fprintf('  exportgraphics                 : available\n');
    else
        fprintf('  exportgraphics                 : not available -> print() export fallback\n');
    end

    fprintf('  test path counts               : %s\n',mat2str(npaths_test(:).'));
catch ME
    fprintf(2,'\nWavelet scattering test FAILED:\n%s\n\n',ME.message);
    rethrow(ME);
end

fprintf('Requirement check PASSED.\n\n');
