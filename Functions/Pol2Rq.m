function [Rq] = Pol2Rq(Iraw)
% Cette fonction permet de calculer une erreur de mesure polarimétrique Rq. 
% Rq = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la caméra polarimétrique
% OUTPUT :
% Rq : Image des différences d'intensités mesurées au sein d'un même
% super-pixel.

[nl, nc, c] = size(Iraw);

if c == 4
    I0 = double(Iraw(:,:,1));
    I45 = double(Iraw(:,:,2));
    I90 = double(Iraw(:,:,3));
    I135 = double(Iraw(:,:,4));
else
    [I0, I45, I90, I135] = SeparPolar(Iraw);
end

Rq = I0 + I90 - I45 - I135; % Les polar sont regroupées chacunes dans leur coin.
end