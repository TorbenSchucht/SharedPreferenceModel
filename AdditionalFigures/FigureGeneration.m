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