function Exercise3_kmeans(gesture, clusters, k)
    dim = size(gesture, 3);
    [samples, n, ~] = size(gesture);
    
    labels = cell(1, k);
    gesture = reshape(gesture, [n*samples, dim]);
    distortion = 99999999;
    prev_distortion = 99999999999999;
    

    
    while prev_distortion - distortion > 10^(-6)
        prev_distortion = distortion;        
        labels = cell(1, k);
        
        %label that shit
        for p = 1:n*samples
            closest_cluster = closestCluster(gesture(p), clusters);
            labels{closest_cluster} = [labels{closest_cluster}; gesture(p, :)];
            
        end
        
        %Recalculate cluster means
        clusters = clusterMean(labels);
        
        distortion = calculate_distortion(labels, clusters);
    end
    
    plotClusters(labels, clusters);
    
end

function closest_cluster = closestCluster(x, clusters)
    n = size(clusters, 1);
    closest_cluster = 1;
    val = Inf;
    
    for i = 1:n
        cur_dist = dist(x, clusters(i));
        
        if cur_dist < val
            closest_cluster = i;
            val = cur_dist;
        end
        
    end

end

function distortion = calculate_distortion(labels, clusters)
    k = size(labels);
    distortion = 0;
    
    for i=1:k
        n = size(labels{i});
        for j = 1:n
            distortion = distortion + (clusters(i)-labels{i}(j))^2;
        end
    end
end

function cluster_mean = clusterMean(labels)
    k = size(labels, 2);
    cluster_mean = zeros(k, 3);
    
    for i = 1:k
        m = mean(labels{i});
        cluster_mean(i, :) = mean(labels{i});
    end
end