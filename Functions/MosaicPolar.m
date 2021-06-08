function [Imos] = MosaicPolar(Iraw)
% Cette fonction permet de séparer les polarisation issues des microgrilles
% de la caméra polarimétrique pour les regrouper ensembles chacune de leur
% coté.
% Imos = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la caméra polarimétrique
% OUTPUT :
% Imos : image séparée en 4 parties. Les polarisation sont regroupées
% ensembles dans un même coin de l'image.

[nl, nc, c] = size(Iraw);

if c == 4
    I0 = double(Iraw(:,:,1));
    I45 = double(Iraw(:,:,2));
    I90 = double(Iraw(:,:,3));
    I135 = double(Iraw(:,:,4));
else
    [I0, I45, I90, I135] = SeparPolar(Iraw);
end

Imos = cat(1,cat(2, I90, I45),cat(2, I135, I0));
end