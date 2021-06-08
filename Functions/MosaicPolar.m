function [Imos] = MosaicPolar(Iraw)
% Cette fonction permet de s�parer les polarisation issues des microgrilles
% de la cam�ra polarim�trique pour les regrouper ensembles chacune de leur
% cot�.
% Imos = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la cam�ra polarim�trique
% OUTPUT :
% Imos : image s�par�e en 4 parties. Les polarisation sont regroup�es
% ensembles dans un m�me coin de l'image.

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