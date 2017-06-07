function [best_p, old_w] = kFolds(In, Out, p_min, p_max, k)
    [~, n] = size(In);
    
    split = floor(n / k); %avoid float indices
    best_p = [1, 1];
    previous_error = [Inf; Inf];
    old_w = cell(1, 3);
    for p = p_min:p_max
        
        current_error = [0; 0];
        
        for i = 1:k-1
        
            %split both input and output into training and test data
            trainingInData = In;
            testInData = trainingInData(:, [i*split : (i+1)*split-1]);
            trainingInData(:, [i*split : (i+1)*split-1]) = [];

            trainingOutData = Out;
            testOutData = trainingOutData(:, [i*split : (i+1)*split-1]);
            trainingOutData(:, [i*split : (i+1)*split-1]) = [];


            %Train weights
            w = linReg(trainingInData, trainingOutData, p);

            %Find error using test data
            phi = makePhi(testInData, p);
            predictions = w * phi;
            error = linRegError(testOutData, predictions);
            current_error = current_error + error;
            
            
        end
        
        %Check if current degree is better than the previous best
        if current_error(1) < previous_error(1)
            previous_error(1) = current_error(1);
            best_p(1) = p;
            old_w{1} = w(1, :)';
            old_w{2} = w(2, :)';
        end
        
        if current_error(2) < previous_error(2)
            previous_error(2) = current_error(2);
            best_p(2) = p;
            old_w{3} = w(3, :)';
        end
        
    end

end

function error = linRegError(Out, pred)
    [~, n] = size(Out);
    diff = Out - pred;
    diff = diff .^ 2;
    diff = [diff(1, :) + diff(2, :); diff(3, :)];
    diff = diff / n;
    diff = sqrt(diff);
    
    error = sum(diff, 2);
end

function w = linReg(In, Out, p)
    phi = makePhi(In, p);
    w = Out * pinv(phi);

end
