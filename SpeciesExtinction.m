function [p,N, spTraitTable] = SpeciesExtinction(p,k,N,opt,spTraitTable)

deadSpecies = find(sum(N,2)< p.Ncrit); % find dead Species
spTraitTable.Survival_Time(p.NIndex(deadSpecies)) = p.t; % Save Generation time, when they got extinct
p.NIndex(deadSpecies) = [];             % Delete index of dead species
N(sum(N,2)< p.Ncrit,:) = 0;             % Set density to 0 of dead species

% delete variables of dead species
p.R(deadSpecies) = [];
p.T(deadSpecies) = [];
p.sig(deadSpecies) = [];
p.theta(deadSpecies) = [];
p.comp(deadSpecies,:) = [];
p.comp(:,deadSpecies) = [];
p.r(deadSpecies,:) = [];
N(deadSpecies,:) = [];
k.Nt(deadSpecies,:) = [];
p.S = p.S-length(deadSpecies); %reduce number of species
p.fk(deadSpecies,:) = [];

end