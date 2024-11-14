%%%%% Function calculates the global and local Shannon-Index of a Matrix N %%%%%
% Author: Torben Schucht

%%% Input %%%
% N: Matrix of species densities at each location in space x
% L: Interval length for calculation of local Shannon-Index (HLocal)

%%% Output %%%
% HGlobal: Scalar of global Shannon-Diversity, based of mean-abundances
% across all of x
% HLocal: Vector of Local Shannon-Index, based on mean abundances of species in an
% interval with length L

function [DGlobal, DLocal] = ShannonIndex(N, L)

%%% Global Shannon-Index %%%

% Calculate mean density of species across whole space x
NMean = mean(N,2);

% Relative abundance of mean density
RelAbun = NMean/sum(NMean);

% Global Shannon-Index
DGlobal = exp(-sum(RelAbun.*log(RelAbun)));

%%% Local Shannon-Index %%%
% Total Nr of bins
BinNr = round(size(N,2)/(2*L));

% Upper and lower boundaries of bins
Bins = linspace(0.25*size(N,2)+L,0.75*size(N,2),BinNr);

DLocal = NaN(BinNr,1); % Preallocate HLocal
z=1; % Counter


for i = Bins
    
    if sum(N(:,i-L+1:i)) < 1e-8 % Values with extremely low densities
        DLocal(z) = 1; % Set to 1 to avoid numeric anomalies
    else
        NMean = mean(abs(N(:,i-L+1:i)),2); % Mean density at bin % abs to avoid tiny negative numbers
        RelAbun = NMean/sum(NMean);   % Relative Abundance
        DLocal(z) = exp(-sum(RelAbun.*(log(RelAbun+1e-10)))); % Calculate local diversity +e-10 to avoid values of exactly 0
    end
    z = z+1; % increase counter
    
end

end


