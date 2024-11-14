% Create plot for how long species survived in relation to their trait
% value 

function [spTraitTable] = SurvivalTime(spTraitTable, p)

    % Generate matrix that saves survival of species
    
    % Species that are not extinct are set to full survival time (t_iter)
    spTraitTable.Survival_Time(spTraitTable.Survival_Time == 0) = p.t_iter;
    
    % Initialize Survival matrix
    SurvMatrix = zeros(p.initS, 1000);
    for i = 1:p.initS
       SurvTime = round((spTraitTable.Survival_Time(i)/p.t_iter) *1000); % Calculate survival time
       SurvMatrix(i, 1:SurvTime) = 1; % Set to 1, at the times where species survived
    end
    
    % Plot survival matrix
    cols = [1,1,1; 0 0 1]; % White for 0, Blue for 1
    
    pcolor(log10(1:10:p.t_iter), spTraitTable.("Trade-Off Value Theta"), SurvMatrix)
    shading flat
    ax = gca;
    colormap(ax, cols)
    xlabel('log(t)')
    ylabel('\theta')
    title('Survival of species')
end
    
   