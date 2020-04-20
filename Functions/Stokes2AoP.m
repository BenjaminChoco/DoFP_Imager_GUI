function Iaop = Stokes2AoP(S1,S2)
% Calcule de l'AoP à partir des coefficients du vecteur de stokes
%
% INPUT : 
% S0,S1,S2 : Coefficients du vecteur de Stokes.
%
% OUTPUT :
% Iaop : Image de l'AoP, ramené à l'intervalle [0:255] (correspondant à l'intervalle [-pi:pi].

% Calcul du DOLP
Iaop = 0.5*atan2(S2,S1);
% Iaop = uint8(255*((pi/2) + Iaop)/pi); 
end