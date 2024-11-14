function [x0,y0] = CalculateIntersections(r,x)
    % Calculate intersections of growth curves
    % --> find areas of maximum r of each species
    Species = size(r,1);
    L = size(r,2);
    
    x0 = zeros(Species-1,1);
    y0 = zeros(Species-1 ,1);
    
    [row,col] = max(r,[],1);            % find Species with highest r at each position
    z = 1;                              % Counter for index position of x0
    for i = 2:L
        if col(i-1) ~= col(i)           % if Species with highest r changes
            x0(z) = mean(x(i-1:i));     % Set x position of intersection
            y0(z) = mean(row(i-1:i));
            z = z+1;
        end
    end
end