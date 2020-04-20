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

% end
[I0, I45, I90, I135] = SeparPolar(Iraw);
Imos = cat(1,cat(2, I90, I45),cat(2, I135, I0)); % Les polar sont regroupées chacunes dans leur coin.
end