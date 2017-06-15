function plotClusters(labels, clusters)
    rotate3d on;
    hold on;
    colors = {'blue'; 'black'; 'red'; 'green'; 'magenta'; 'yellow'; 'cyan'};
    title('nubs');
    for i = 1:size(colors, 1)
        scatter3(labels{i}(:, 1), labels{i}(:, 2), labels{i}(:, 3));%, colors(i));
        scatter3(clusters(:, 1), clusters(:, 2), clusters(:, 3));%, colors(i));
    end

end
