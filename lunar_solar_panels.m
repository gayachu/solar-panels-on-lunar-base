% simple_panel_sim.m
% Solar panel damage sim (radiation + meteors + crack propagation)

clear; close all; rng("shuffle");

nx = 60; ny = 30;           % panel grid
Tyears = 60;                % total simulated years
h = ones(ny,nx);            % health (1 = perfect, 0 = destroyed)


% parameters
rad_loss = 0.01;            % radiation damage per year
p_hit = 0.01;               % probability of meteor hit per cell per year
hit_damage = 0.2;           % fixed damage if hit
crack_spread_rate = 0.1;   % how strongly cracks spread

% crack propagation kernel (Laplacian-like)
K = [0.05 0.1 0.05;
     0.1  -1  0.1;
     0.05 0.1 0.05];

for t = 1:Tyears
    % --- radiation ---
    h = h - rad_loss;
    
    % --- meteors ---
    hits = rand(ny,nx) < p_hit;
    h = h - hit_damage .* hits;
    
    % --- crack propagation (convolution on damage field) ---
    damage = 1 - h;
    crack_spread = conv2(damage, K, 'same');
    h = h - crack_spread_rate * crack_spread;
    
    
    
    % --- clip ---
    h = max(0,h);
    
    
    % --- visualize ---
    if mod(t,5)==0 || t==Tyears
        
        imagesc(h,[0 1]); axis image off; colormap("jet");
        title(sprintf('Health after %d years',t));
        
        
        
        drawnow;
    end
end
