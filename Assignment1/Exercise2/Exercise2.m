function [best_d, class_err, conf_mat] = Exercise2(d_max)
    images = loadMNISTImages('train-images.idx3-ubyte');
    labels = loadMNISTLabels('train-labels.idx1-ubyte');

    hitData = zeros(60, 1);


    %Perform PCA
    [pc, image_mean] = eigenPCA(images, d_max);

    testImages = loadMNISTImages('t10k-images.idx3-ubyte');
    testLabels = loadMNISTLabels('t10k-labels.idx1-ubyte');
    zeroMeanTest = testImages - image_mean(:,1:size(testImages,2));
    zeroMeanTrain = images - image_mean;
    n = size(testImages, 2);
    clear images testImages;

    best_hits = 0;
    best_d = 1;
    best_predictedLabels = zeros(1, 10000);
    
    for d = 1:d_max
        cur_pc = pc(:, end-d+1:end);
        proj_images = cur_pc'*zeroMeanTrain;

        %Find mean and cov of each class of the projected data
        [proj_mean, proj_cov] = proj_mean_cov(proj_images, labels, d);

        %Project test data
        proj_test = cur_pc'*zeroMeanTest;
        hits = 0;

        for i = 1:n

            likelihood = zeros(10, 1);
            for class = 1:10
                likelihood(class) = mvnpdf(proj_test(:, i)', proj_mean(:, class)', proj_cov(:, :, class));
            end

            [val, predictedLabels(i)] = max(likelihood);
            predictedLabels(i) = predictedLabels(i) - 1;

            %Hit
            if predictedLabels(i) == testLabels(i)
                hits = hits + 1;
            end
        end

        hitData(d) = hits;
        if hits > best_hits
           best_hits = hits;
           best_d = d;
           best_predictedLabels = predictedLabels;
        end
    end
    class_err = n-best_hits;
    conf_mat = confusionmat(testLabels, predictedLabels);
    
end
