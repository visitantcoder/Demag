function model = classifier_fit_model(X,y,name)
switch lower(name)

    case 'nearest_centroid'
        classes=unique(y(:));
        centroids=zeros(numel(classes),size(X,2));

        for i=1:numel(classes)
            centroids(i,:)=mean(X(y==classes(i),:),1);
        end

        model.type='nearest_centroid';
        model.classes=classes;
        model.centroids=centroids;

    case 'lda'
        model=fitcdiscr(X,y,'DiscrimType','pseudoLinear');

    case 'knn'
        nTrain=size(X,1);
        k=max(1,min(5,floor(sqrt(nTrain))));
        if mod(k,2)==0, k=k-1; end
        k=max(1,k);

        model=fitcknn(X,y, ...
            'NumNeighbors',k, ...
            'Distance','euclidean', ...
            'Standardize',false);

    case 'svm_linear'
        t=templateSVM( ...
            'KernelFunction','linear', ...
            'BoxConstraint',1, ...
            'Standardize',false);

        model=fitcecoc(X,y, ...
            'Learners',t, ...
            'Coding','onevsone');

    case 'svm_rbf'
        try
            t=templateSVM( ...
                'KernelFunction','rbf', ...
                'KernelScale','auto', ...
                'BoxConstraint',1, ...
                'Standardize',false);
        catch
            t=templateSVM( ...
                'KernelFunction','rbf', ...
                'BoxConstraint',1, ...
                'Standardize',false);
        end

        model=fitcecoc(X,y, ...
            'Learners',t, ...
            'Coding','onevsone');

    otherwise
        error('Unknown classifier: %s',name);
end
end
