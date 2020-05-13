function S = Raw2Stokes_Fourier(Iraw, appod, padding)

% Function dedicated to determine the Stokes vector image from the raw
% image from the DoFP camera.

% Input:
% Iraw : raw image from the DoFP camera

% Output:
% S : Image du vecteur de Stokes dans la scène. (3 canaux)

[nl,nc] = size(Iraw);
Iraw = double(Iraw); 
% Passage dans l'espace de Fourier discret :
If = fftshift(fft2(double(Iraw)));

% Création de la matrice pour l'appodisation
if appod == true
%     G = GaussMat([341, 408],0,[1024, 1224]);
%     G = GaussFlat([150, 150],[1024, 1224],0.5);
    y= hann(nl/2,'periodic');
    x = hann(nc/2,'periodic');
    [X,Y] = meshgrid(x,y);
    G = X.*Y;
else
    G = ones(1024, 1224);
end

if padding == false
    
    % Séparation des 3 termes de cette transformée (S0, S1+S2 et S1-S2)

    S0f = If(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc).*G / 4; % Terme contenant l'information sur S0
    S1pS2f = -4*cat(2,If(0.25*nl+1:0.75*nl,0.75*nc+1:nc),If(0.25*nl+1:0.75*nl,1:0.25*nc)).*G / 4; % Terme contenant l'information sur S1+S2
    S1mS2f = -4*cat(1,If(0.75*nl+1:nl,0.25*nc+1:0.75*nc),If(1:0.25*nl,0.25*nc+1:0.75*nc)).*G / 4; % Terme contenant l'information sur S1-S2
else
    % On utilise un zéro-padding pour ramener l'image à sa taille pleine
    % résolution
    S0f = zeros(size(Iraw));
    S1pS2f = zeros(size(Iraw));
    S1mS2f = zeros(size(Iraw));
    
    S0f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = If(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc).*G; % Terme contenant l'information sur S0
    S1pS2f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = -4*cat(2,If(0.25*nl+1:0.75*nl,0.75*nc+1:nc),If(0.25*nl+1:0.75*nl,1:0.25*nc)).*G; % Terme contenant l'information sur S1+S2
    S1mS2f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = -4*cat(1,If(0.75*nl+1:nl,0.25*nc+1:0.75*nc),If(1:0.25*nl,0.25*nc+1:0.75*nc)).*G; % Terme contenant l'information sur S1-S2
end

% Transformées de Fourier inverses pour retrouver les termes S0, S1+S2 et S1-S2 et donc S1 et S2
S0 = real(ifft2(fftshift(S0f))) * 2;
S1pS2 = real(ifft2(fftshift(S1pS2f)));
S1mS2 = real(ifft2(fftshift(S1mS2f)));

% On retrouve S1 et S2 à partir des termes S1+S2 et S1-S2:
S1 = (S1pS2 + S1mS2)/2;
S2 = (S1pS2 - S1mS2)/2;

S = cat(3, S0, S1, S2);

end