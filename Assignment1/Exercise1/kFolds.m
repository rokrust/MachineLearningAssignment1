function w = kFolds(In, Out, p_min, p_max, k)
    [~, n] = size(In);
    
    split = floor(n / k); %avoid float indices
    best_p = 1;
    
    for p1 = p_min:p_max
        for p2 = p_min:p_max
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
                w_new = linReg(trainingInData, trainingOutData, p1, p2);
        
                %Find error using test data
                phi = makePhi(testInData, max(p1, p2));
                predictions = w_new * phi;
                error = linRegError(testOutData, predictions);
                current_error = current_error + error;
            
        
            end
            
            
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

function w = linReg(In, Out, p1, p2)
    max_p = max(p1, p2);
    phi = makePhi(In, max_p);
    
    %Split calculation of weights in two because of the different p's
    w_trans = Out(1:2, :) * pinv(phi(1:3*p1 + 1, :));
    w_rot = Out(3, :) * pinv(phi(1:3*p2 + 1, :));
    
    %Concatenate and zero pad if needed
    w = [w_trans, zeros(2, 3*(max_p - p1)); w_rot, zeros(1, 3*(max_p - p2))];
end
