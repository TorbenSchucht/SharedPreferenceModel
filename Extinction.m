function [p, N, Species, fk] = Extinction(p,N,ExtThreshold,MethodMeta, fk)

if strcmp(MethodMeta, 'selected')
    % Species cleanup (delete dead species)
    N(sum(N,2)< ExtThreshold,:) = 0;            % Set densities to 0
    Species = size(N,1);   
elseif strcmp(MethodMeta, 'curve') && any(sum(N,2)< ExtThreshold)
    deadSpecies = find(sum(N,2)< ExtThreshold); % find dead Species
    %NSurvivalTime.Survival_Time(NIndex(deadSpecies)) = t; % Save Generation time, when they got extinct
    %NIndex(deadSpecies) = [];           % Delete index
    N(sum(N,2)< ExtThreshold,:) = 0;            % Set densities to 0
    
    % delete Species variables
    p.R(deadSpecies) = [];
    p.T(deadSpecies) = [];
    p.sig(deadSpecies) = [];
    p.z(deadSpecies) = [];
    p.comp(deadSpecies,:) = [];
    p.comp(:,deadSpecies) = [];
    p.r(deadSpecies,:) = [];
    p.ThetaSpecies(deadSpecies) = [];
    N(deadSpecies,:) = [];
    %Nt(deadSpecies,:) = [];
    Species = Species-length(deadSpecies); %reduce number of species
    fk(deadSpecies,:) = [];
end


end