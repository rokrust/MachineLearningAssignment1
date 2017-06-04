function phi = makePhi(In, deg)
    [~, n] = size(In);
    prod = In(1, :) .* In(2, :);
    
    phi = ones(1, n);
    
    %Make phi matrix
    for p = 1:deg
        phi = [phi; In .^ p];
        phi = [phi; prod .^ p];
    end
end
