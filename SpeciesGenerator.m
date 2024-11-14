function [p,N] = SpeciesGenerator(p, opt)
                        
        %%% Generate species traits %%%           
        p.theta = linspace(0,p.thetaMax,p.S)';              % Trait values theta
        p.R = p.Rmax./(1+exp(-(p.beta + p.theta)))+1;       % Generate max.Growth rates
        p.T = p.Tmax./(1+exp(-p.beta + p.theta));           % Generate Tolerances       
        p.xOpt = linspace(p.xOpt,p.xOpt,p.S)';              % Same optimum / Shared preferences
        p.xProj = linspace(0, 1, p.L/2); 
        
        %%% Growth functions %%%
        p.r = 1./(sqrt(2*pi.*p.T.^2)).*exp((-abs(p.x-p.xOpt).^2)./(2.*p.T)).*(p.T*sqrt(2*pi)).*p.R;
  
        % Initialize densities
        N = ones(p.S, p.L) .* p.N0; 
        
        %%% Dispersal kernels %%%
        p.sig = repmat(p.sigma, p.S, 1); % Dispersal width (same for every species)
        p.k = 1./sqrt(2.*p.sig.^2).* exp(-sqrt(2./(p.sig.^2))*abs(p.x)); % Laplace Kernel
        p.fk = zeros(size(N,1),p.L); % Predefine fast-fourier transform of k
        for i = 1:p.S
            p.fk(i,:) = fft(p.k(i,:)); % calculate fft(k)
        end
        
        % Competition matrix
        p.comp = repmat(p.alphaij, p.S, p.S);
        
        % Assign species indices
        p.NIndex = 1:p.S;
        
        %% Optional Plots %%
        
        % Plot of dispersal kernel (first Species)
        if opt.plotDispersalKernel == 'y'
            figure()
            plot(p.x, p.k(1,:))
            xlabel('\Deltax')
            ylabel('k(\Deltax)')
            title('Dispersal kernel')
        end
        
        % Plot of community growth rates
        if opt.plotGrowthFunctions == 'y'
            figure()
            for i = 1:p.S
                plot(p.x, p.r(i,:))
                hold on
            end
            hold off
            xlabel('x')
            ylabel('r_{i}(x)')
            title('Community growth rate functions')
            xlim([-p.l/2, p.l/2]) % Do not display area with PAD    
            
            % Obtain intersection locations
            [x0,y0] = CalculateIntersections(p.r,p.x)
            xline(x0,'--') % add intersections
        end
end
    