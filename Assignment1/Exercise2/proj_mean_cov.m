function [mean_proj, cov_proj] = proj_mean_cov(proj_data, labels, d)
    mean_proj = zeros(d, 10);
    cov_proj = zeros(d, d, 10);
    
    for class = 0:9

        classData = proj_data(:, labels' == class)';
        mean_proj(:,class+1) = mean(classData)';
        cov_proj(:,:,class+1) = cov(classData);
    end
end    