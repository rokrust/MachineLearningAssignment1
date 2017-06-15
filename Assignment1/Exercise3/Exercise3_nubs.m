function Exercise3_nubs(gesture, k)
    [samples, n, dim] = size(gesture);
    gesture = reshape(gesture, [n*samples, dim]);
    
    labeled_data = cell(1, k);
    labeled_data{1} = gesture;
    
    clusters = zeros(k, 3);
    clusters(1, :) = mean(gesture);
    cur_k = 1;
    
    while cur_k < k
        split = mostDistortedCluster(clusters, labeled_data, cur_k);
        cur_k = cur_k + 1;
        [clusters(split, :), clusters(cur_k, :), labeled_data{split}, labeled_data{cur_k}] = splitCluster(clusters(split), labeled_data{split});
        
    end
    plotClusters(labeled_data, clusters);
end


function [cluster1, cluster2, labeled_data1, labeled_data2] = splitCluster(cluster, points)
    [samples, dim] = size(points);
    
    v = randi(10, 1, dim) - 5;
    
    cluster1 = cluster + v;
    cluster2 = cluster - v;
    
    labeled_data1 = [];
    labeled_data2 = [];
    
    %Split data
    for i = 1:samples
        if dist(cluster1, points(i)) < dist(cluster2, points(i))
            labeled_data1 = [labeled_data1; points(i, :)];
        
        else
            labeled_data2 = [labeled_data2; points(i, :)];
            
        end
    end
    
    cluster1 = mean(labeled_data1);
    cluster2 = mean(labeled_data2);
end

function distorted_cluster_index = mostDistortedCluster(clusters, labeled_data, cur_k)
    biggest_distortion = 0;
    
    for i = 1:cur_k
        distortion = calculateDistortion(clusters(i), labeled_data{i});
        if biggest_distortion < distortion
            biggest_distortion = distortion;
            distorted_cluster_index = i;
        end
        
    end

end

function total_distortion = calculateDistortion(cluster, points)
    [n, dim] = size(points);
    total_distortion = 0;
    for i = 1:n
        total_distortion = total_distortion + dist(cluster, points(i));
    end
end