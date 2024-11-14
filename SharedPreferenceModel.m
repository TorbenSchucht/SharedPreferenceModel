%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Shared Preference Model %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulates competition of S species in a continous space x and discrete
% time t with shared preferences of growth optima

% Clear workspace
close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZE PARAMETERS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

opt = struct(); % Options struct
p = struct();   % Parameter struct

%% Options %%
opt.plotDispersalKernel = 'n';          % Disp. Kernel
opt.plotGrowthFunctions = 'n';          % All growth functions
opt.plotCommunityAtGivenTime = 'n';     % Density curves at given times
opt.CommunityPoints = [1,2,5,30,10000,100000]; % timepoints where species community is plotted (only if opt.plotCommunityAtGivenTimes is y)
opt.plotTemporalDensity = 'n';          % Species densities over t
opt.plotSurvivalTime = 'n';             % Survival time based on trade-off value theta
opt.SpeciesExtinction = 'y';            % Enable species extinction
opt.LivePlot = 'n';                     % Create community plot during simulation (Animation)

% Parameters
p.beta = -0.7;                        % Shape of trade-off curve
p.Tmax = 5;                           % Max. value of Tolerance T
p.Rmax = 5;                           % Max. value of maximum growth rate, R
p.alphaij = 1;                        % competition coefficients (all interactions)
p.L = 1024;                           % Spatial resolution of gradient x
p.S = 25;                             % Number of generated species
p.thetaMax = 3;                       % max. position on trade-off axis
p.t_iter = 10000;                     % number of iterations
p.l = 1.6;                            % Spatial size of gradient (from -l/2 to  l/2)
p.Ncrit = 0.01;                       % Extinction threshold
p.N0 = 0.01;                          % Initial density
p.sigma = 0.03;                       % Dispersal width

% Initialize space
p.xOpt = -p.l/2;                        % Position of optimal growth
p.dx = p.l*2/p.L;                       % define dx based on L
p.x = linspace(-p.l,p.l-p.dx,p.L);      % create continuous space
p.PAD = (abs(p.x)<=p.l/2);              % padding outside [-l/2, l/2]
p.initS = p.S;                          % save initial species number

%%%%%%%%%%%%%%%%%%%%%%%%
%% Species Generation %%
%%%%%%%%%%%%%%%%%%%%%%%%

[p,N] = SpeciesGenerator(p, opt);       % Generate species with traits

spTraitTable = GenerateTraitTable(p);   % Trait table that saves ID,R,T,theta,Survival time

%%%%%%%%%%%%%%%%%%
%% SIMULATE RUN %%
%%%%%%%%%%%%%%%%%%

k = PredefineResultMatrices(p, opt);

for t = 1:p.t_iter
    p.t = t;

    N = NewDensities(N, p); % Calculate new densities
    if opt.SpeciesExtinction == 'y' && any(sum(N,2) < p.Ncrit)
        [p,N, spTraitTable] = SpeciesExtinction(p, k, N, opt, spTraitTable);
    end

    % Plot densities during simulation
     if opt.LivePlot == 'y' || any(opt.CommunityPoints == p.t)
         k.idx = k.idx + 1;
         figure(1)
         subplot(1,length(opt.CommunityPoints),k.idx)
         CommunityPlot(p,N)
         k.NDist(p.NIndex, : ,k.idx ) = (N(:,p.L*0.25+1:0.75*p.L) > 0.1); % Distributions larger than 0.1
         k.NSaved(p.NIndex,: ,k.idx ) = N; % Save N
     end
    
    if mod(p.t,10) == 0  % Every 10 timesteps save sum of densities
        p.Nt(p.NIndex,t/10) = sum(N,2); % Sum up densities --> save to Nt
    end
    
    if any(k.DPoints == p.t)
       k.DGIdx = k.DGIdx + 1;
       [DG, DL] = ShannonIndex(N, k.dRes); % Calculate Shannon index
       idx = find(k.DPoints == p.t);
       for i = idx
            k.DLocal(:, i) = DL;
       end
       k.DGlobal(k.DGIdx) = DG;
    end

    % if 1% of simulation is completed
    if mod(p.t,p.t_iter*0.01) == 0
        UpdateWaitbar(p, k)
    end    
end 
     

%%%%%%%%%%%%%%%%%%
%% PLOT RESULTS %%
%%%%%%%%%%%%%%%%%%

% Plot Community at first 3 points (set in opt.CommunityPoints)
figure()
subplot(3,2,1)
p.t = opt.CommunityPoints(1);
CommunityPlot(p,k.NSaved(:,:,1))
subplot(3,2,3)
p.t = opt.CommunityPoints(2);
CommunityPlot(p,k.NSaved(:,:,2))
subplot(3,2,5)
p.t = opt.CommunityPoints(3);
CommunityPlot(p, k.NSaved(:,:,3))
% Plot temporal diversity pattern
subplot(3,2,[2,4,6])
DiversityPlot(p,k)

% Plot Species extinctions and clusters
figure()
subplot(2,2,1)
spTraitTable = SurvivalTime(spTraitTable, p);
subplot(2,2,2)
PlotSpeciesClusters(p,N)
subplot(2,2,3)
PlotExtinctionBins(p,k,spTraitTable)

close(k.wb) % Close waitbar



%%%%%%%%%%%%%%%
%% FUNCTIONS %%
%%%%%%%%%%%%%%%

%%% Main function %%%
function N = NewDensities(N, p)

if size(N,1) == 1
    % calculate growth
    f = p.r.*N.*exp(squeeze(-(p.comp.*N)));
else
    % Calculate growth
    f = p.r.*N.*exp(-p.comp*N);
end

% Calculate next density
N_next = p.dx*real( fftshift(ifft(fft(f,[],2).*p.fk,[],2),2));

N_next = N_next.*p.PAD;     % Delete densities in PAD area to avoid periodicity
N = N_next;                 % Set N as current timestep

end

function PlotSpeciesClusters(p,N)
[~, idx] = max(N, [], 2);
idx = idx - p.L/4;
scatter(p.xProj(idx), p.theta, 20, 'filled')
xlabel('x_{max}')
ylabel('\theta')
end

function PlotExtinctionBins(p,k,spTraitTable)

% Plot logarithmic bins of extinction numbers
ExtEvents = spTraitTable.(2);
ExtEvents = ExtEvents(spTraitTable.(2) < p.t_iter);
histogram(log10(ExtEvents),100)
ylabel('Extinctions')
xlabel('t')

% Add Global diversity
hold on
yyaxis right
plot(log10(k.DPoints),k.DGlobal,'LineWidth',2)
ylabel('D_{Global}')

end
