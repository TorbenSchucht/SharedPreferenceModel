% Plot the densities of each species in the community

function CommunityPlot(p,N)
cols = lines(p.initS); % Define colors
count = 0;
    for i = p.NIndex % Loop through species indices
        count = count+1;
        plot(p.xProj, N(count,round(p.L*0.25)+1:round(p.L*0.75)), 'Color', cols(i,:)) % Plot density curve of species
        hold on
    end
    hold off
    
    % Labels and titles
    xlabel('x')
    ylabel('N_{i}')
    title(sprintf('Densities N_{i} at t = %i', p.t))    
    
    % Axis
    xlim([0, 1])
    ylim([0, max(max(N))])
    drawnow
end