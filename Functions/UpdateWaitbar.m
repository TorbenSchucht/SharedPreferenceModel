function UpdateWaitbar(p,k)       
        % Update loading bar and estimate remaining time
        time = toc;
        if time*((1-(p.t/p.t_iter))*100) <= 60
            waitbar(p.t/p.t_iter,k.wb,sprintf('Simulation in progress %d%% \n Time remaining: %.0f seconds',[round(p.t/p.t_iter*100), time*((1-(p.t/p.t_iter))*100)]));
        elseif time*((1-(p.t/p.t_iter))*100) > 60 && time*((1-(p.t/p.t_iter))*100) < 60*60
            waitbar(p.t/p.t_iter,k.wb,sprintf('Simulation in progress %d%% \n Time remaining: %.0f minutes',[round(p.t/p.t_iter*100), time*((1-(p.t/p.t_iter))*100/60)]));
        elseif time*((1-(p.t/p.t_iter))*100) > 60*60
            waitbar(p.t/p.t_iter,k.wb,sprintf('Simulation in progress %d%% \n Time remaining: %.0f hours',[round(p.t/p.t_iter*100), time*((1-(p.t/p.t_iter))*100/60/60)]));
        end
        tic
end