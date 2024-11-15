%% Early development of 1,2 and 25 species in first 100 timesteps

% Plot development of single species
load('1SpeciesConcept.mat')
figure(2)
SIdx = 0; % Subplot index
TimePoints = [0,1,5,10,100]; % Selected timepoints

for t = TimePoints
    SIdx = SIdx + 1;
    subplot(3,5,SIdx)
    N = NTime.(sprintf('t%i',t));    
    % Plot each species
    for i = 1:size(N,1)
        plot(xProj ,N(i,:),'Linewidth', 0.8)
        hold on
        ylim([0 2])
    end
    hold off
    if SIdx == 1
        ylabel('N_{i}')
    end
    xticks([])
    text(0.6,1.80,sprintf('t = %d',t))
end

% Development of two species
load('2SpeciesConcept.mat')
figure(2)
SIdx = 5;
TimePoints = [0,10,40,50,100];
for t = TimePoints
    SIdx = SIdx + 1;
    subplot(3,5,SIdx)
    N = NTime.(sprintf('t%i',t));
    % Plot each species
    for i = 1:size(N,1)
        plot(xProj,N(i,:),'Linewidth', 0.8)
        hold on
        ylim([0 2])
    end
    hold off
    if SIdx == 6
        ylabel('N_{i}')
    end
    xticks([])
    
    %xticks([0, 0.5, 1]);
    %xticklabels({'0', '0.5', '1'});
    text(0.6,1.80,sprintf('t = %d',t))
end

% Development of 25 species
load('25SpeciesConcept.mat')
figure(2)
SIdx = 10;
TimePoints = [1,2,5,30,100];
for t = TimePoints
    SIdx = SIdx + 1;
    subplot(3,5,SIdx)
    N = NTime.(sprintf('t%i',t));
    % Plot each species
    for i = 1:size(N,1)
        plot(xProj,N(i,:),'Linewidth', 0.8)
        hold on
    end
    hold off
    if SIdx == 11
        ylabel('N_{i}')
    end
    xlabel('x')
    text(0.65,max(max(N))*0.9,sprintf('t = %d',t))
end

%%
%% Survival matrix (500 Species simulation)
load('500SpeciesFull.mat')

figure(4)
subplot(2,5,4:5)
ThetaValues = NSurvivalTime.(3);
SurvivedSpecies = NSurvivalTime.SpeciesID(NSurvivalTime.Survival_Time == 1000000);
NxPad = N(:,0.25*p.L+1:0.75*p.L); % N without outside pad
[~,Nmax] = max(NxPad,[],2);
scatter(xProj(Nmax*2),ThetaValues(SurvivedSpecies),20,'filled')
xlabel('x_{max}')
ylabel('\theta')
text([0.05, 0.25, 0.4, 0.5, 0.65, 0.85], [3, 2.1, 1.5, 1.1, 0.8, 0.3], ["1", "13", "23", "29", "19","6"], "FontSize", 10);
xlim([0, 1])
ylim([0, 3])

subplot(2,5,1:3)
TotalSp = length(Rsort);
for i = 1:TotalSp
   ExtPoint = NSurvivalTime.Survival_Time(i);
   plot([0,log10(ExtPoint)], [NSurvivalTime.(3)(i), NSurvivalTime.(3)(i)], 'blue')
   hold on
end
hold off
ax = gca;
ax.InnerPosition(1) = 0.06;
pbaspect([1, 0.78, 0.78])
xlabel('log(t)')
ylabel('\theta')
xlim([3,6])

subplot(2,5,9:10)
plotCommunity(xProj,N,t)
xlabel('x')
hold on
[~, D] = ShannonIndex(N, 4);
yyaxis right
plot(xProj(2:8:end),D,'LineWidth', 2)
ylabel('D_{l}')
str = sprintf('t = 10^{%d}',log10(t));
xL=xlim;
yL=ylim;
text(0.99*xL(2),0.99*yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')


subplot(2,5,6:8)
ExtEvents = NSurvivalTime.(2);
ExtEvents = ExtEvents(NSurvivalTime.(2)<1000000);
histogram(log10(ExtEvents),100)
xlim([3, 6])
ylabel('Extinctions')
xlabel('log(t)')
% Add Global diversity
hold on
yyaxis right
plot(log10(HPoints),HGlobal,'LineWidth',2)
ax = gca;
ax.InnerPosition(1) = 0.06;
pbaspect([1, 0.78, 0.78])
ylabel('D_{Global}')


%% Community and temporal diversity patterns for different dispersal widths

load('IncreasingDispersalSingleSimulations')

figure(5)
% Communities for different sigma
CommIdx = [1, 30, 100];
SubplotIdx = [5,3,1];
for i = 1:length(CommIdx)
    subplot(3,2,SubplotIdx(i))
    plotCommunity(xProj,NendMatrix(:,:,CommIdx(i)),t)
    ttlString = sprintf('\\sigma = %.g \n t = 10^{%d}', sigmaIncrease(CommIdx(i)),log10(t));
    if i == 1
       ttlString = sprintf('\\sigma = %.g \n t = 10^{%d}', sigmaIncrease(CommIdx(i)),log10(t));
    end
    xL=xlim;
    yL=ylim;
    text(0.99*xL(2),0.99*yL(2),ttlString,'HorizontalAlignment','right','VerticalAlignment','top')

    if i == 1
       xlabel('x') 
    end
    N = NendMatrix(:,:,CommIdx(i));
    biomass = sum(N,1);
    hold on
    plot(linspace(0,1,round(L/2)), biomass(round(L*0.25)+1:round(L*0.75)), 'black--')
    hold off
    ylabel('N_{i}')
end

% Colored diversity for different sigmas
subplot(3,2,[2,4,6])
cutoff = 100; % Stop point
HLocalEnd = squeeze(HLocalMatrix(:,99,1:cutoff));
y = sigmaIncrease(1:cutoff);
pcolor(xP,y,HLocalEnd')
shading interp
a = colorbar();
ylabel('\sigma');
xlabel('x');
colormap('jet')
ylabel(a, 'D_{l}', 'FontSize', 9)

%%
% Function to plot Community composition
function plotCommunity(x,N,t)
    for i = 1:size(N,1)
        plot(x(1:2:end),N(i,size(N,2)*0.25:(size(N,2)*0.75)-1),'Linewidth', 0.8)
        hold on
    end
hold off
ylabel('N_{i}')
xlabel('x')
end

