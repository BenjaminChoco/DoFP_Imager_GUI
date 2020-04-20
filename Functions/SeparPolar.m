function [I0, I45, I90, I135] = SeparPolar(Iraw)
% Cette fonction permet de séparer les polarisation issues des microgrilles
% de la caméra polarimétrique pour les regrouper ensembles chacune de leur
% coté.
% Imos = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la caméra polarimétrique
% OUTPUT :
% I0, I45, I90, I135 : quatre images des différentes polarisations

Ndims = ndims(Iraw);
if Ndims == 2
    [nl, nc] = size(Iraw);
    
    % Séparation des polarisations
    I90 = Iraw(1:2:nl,1:2:nc); % pixels haut-gauche
    I45 = Iraw(1:2:nl,2:2:nc); % pixels haut-droite
    I135 = Iraw(2:2:nl,1:2:nc); % pixels bas-gauche
    I0 = Iraw(2:2:nl,2:2:nc); % pixels bas-droite
end
if Ndims == 3
    [nl, nc, c] = size(Iraw);
    
    % Séparation des polarisations
    I90 = Iraw(1:2:nl,1:2:nc,:); % pixels haut-gauche
    I45 = Iraw(1:2:nl,2:2:nc,:); % pixels haut-droite
    I135 = Iraw(2:2:nl,1:2:nc,:); % pixels bas-gauche
    I0 = Iraw(2:2:nl,2:2:nc,:); % pixels bas-droite
end
end