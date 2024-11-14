function k = PredefineResultMatrices(p, opt)

% k --> struct that contains different results matrices / vectors etc.
k = struct();
k.dRes = 4; % Diversity binsize

if p.t_iter >= 100
    k.Nt = zeros(p.S, p.t_iter/100);            % Predefine density at each timestep
end
k.DGlobal = zeros(1,100);                           % Predefine Global diversity
k.DLocal = zeros((p.L/2)/k.dRes,100);               % Predefine local diversity
k.DPoints = round(logspace(1,log10(p.t_iter),100));              % Log points where diversity is saved

k.DGIdx = 0;
k.Nmax = NaN(p.S, p.t_iter/10);             % Predefine matrix for position of maximum density
k.NmaxValue = NaN(p.S, p.t_iter/10);         % Predefine matrix that saves maximum density
k.NDist = zeros(p.S, p.L/2, length(opt.CommunityPoints));
k.NSaved = zeros(p.S, p.L, length(opt.CommunityPoints));

k.wb = waitbar(0,'Simulation in progress...');% create loading bar
tic

% Create reprojection of x to a space of 0 to 1
p.xProj = (p.x+p.l)*1/(p.l*2);
k.biomassTime = struct();
k.NTime = struct();
k.idx = 0;
k.SIdx = 0; % Idx used for subplot of communities

end