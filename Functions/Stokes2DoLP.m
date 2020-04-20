function Idolp = Stokes2DoLP(S0,S1,S2)
% Calcule le DOLP à partir des coefficients du vecteur de stokes
%
% INPUT : 
% S0,S1,S2 : Coefficients du vecteur de Stokes.
%
% OUTPUT :
% Idolp : Image du DoLP, ramenée dans l'intervalle [0,255].

% Calcul du DOLP
Idolp = sqrt(S1.^2+S2.^2)./S0;
end