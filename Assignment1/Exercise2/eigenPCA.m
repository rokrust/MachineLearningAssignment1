function [pc, image_mean] = eigenPCA(images, d)
    image_mean = repmat(mean(images')', 1, size(images,2));
    
    %Find mean and cov
    zero_mean_images = images - image_mean;
    image_covariance = cov(zero_mean_images');
    
    [cov_eig_vec, ~] = eig(image_covariance);
    pc = cov_eig_vec(:, end-(d-1):end);

end