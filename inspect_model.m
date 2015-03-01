function inspect_model(V, movieData, k)

if nargin < 3
    k = 5;
end

nDims = size(V,2);

%Inspect results
for d=1:nDims

    fprintf('Hidden dimension %d\n', d);
    
    [~,I] = sort(V(:,d));

    neg = I(1:k);
    pos = I(end-k+1:end);
    
    for j = neg(:)'
        fprintf('  %.2f <a href="%s">%s</a>\n', V(j,d), movieData.imdb_url{j}, movieData.title{j});
    end

    fprintf('  ...\n');
    fprintf('  ...\n');
    for j = pos(:)'
        fprintf('  %.2f <a href="%s">%s</a>\n', V(j,d), movieData.imdb_url{j}, movieData.title{j});
    end

    fprintf('\n');
end