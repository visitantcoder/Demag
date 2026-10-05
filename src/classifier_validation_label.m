function txt = classifier_validation_label(mode)
if strcmp(mode,'PROTOTYPE_AUGMENTATION_CV')
    txt = 'Prototype CV using augmented variants (not final independent-test accuracy)';
elseif strcmp(mode,'GROUPED_BY_SOURCE_FILE')
    txt = 'Source-file-grouped cross-validation';
else
    txt = strrep(mode,'_',' ');
end
end
