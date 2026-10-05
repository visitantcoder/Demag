function s = classifier_safe_feature_name(s)
s=regexprep(s,'[^a-zA-Z0-9_]','_');

if isempty(s)
    s='Feature';
end

if ~isletter(s(1))
    s=['F_' s];
end

% Older MATLAB table variable-name limit is commonly 63 characters.
if numel(s)>60
    s=s(1:60);
end
end
