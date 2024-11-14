function [spTraitTable] = GenerateTraitTable(p)


% Create table that saves Species data regarding ID, traits, and survival
% time
varTypes = {'double','double','double','double','double'};
varNames = {'SpeciesID', 'Survival_Time','Trade-Off Value Theta','max. Growth R', 'Tolerance T'};
spTraitTable = table('Size',[p.S,length(varNames)], 'VariableTypes', varTypes, 'VariableNames', varNames);
spTraitTable.SpeciesID(1:p.S) = 1:p.S; % Add ID for each species
spTraitTable.("Trade-Off Value Theta")(1:p.S) = p.theta;  % Save trade-off position of initial species
spTraitTable.("max. Growth R")(1:p.S) = p.R;         % Save max. growth parameters of initial species 
spTraitTable.("Tolerance T")(1:p.S) = p.T;           % Save Tolerance parameters of initial species


end