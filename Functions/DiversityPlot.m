function DiversityPlot(p,k)

% Generate a coloured plot of the temporal pattern of diversity
pcolor(p.xProj(1:size(p.xProj,2)/size(k.DLocal,1):end), log10(k.DPoints), k.DLocal(:,1:100)')
title('Local Diversity D_{l}')
ylabel('log(t)');
shading interp
colormap('jet')
a = colorbar();
ylabel(a, 'D_{l}', 'FontSize', 8)
xlabel('x')

end