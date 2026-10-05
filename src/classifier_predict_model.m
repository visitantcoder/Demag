function pred = classifier_predict_model(model,X,name)
switch lower(name)

    case 'nearest_centroid'
        n=size(X,1);
        d=zeros(n,numel(model.classes));

        for i=1:numel(model.classes)
            D=bsxfun(@minus,X,model.centroids(i,:));
            d(:,i)=sum(D.^2,2);
        end

        [~,idx]=min(d,[],2);
        pred=model.classes(idx);

    otherwise
        pred=predict(model,X);
end

pred=double(pred(:));
end
