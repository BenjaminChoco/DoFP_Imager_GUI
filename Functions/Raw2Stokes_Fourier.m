function S = Raw2Stokes_Fourier(Iraw, appod, padding)
% Function dedicated to determine the Stokes vector image from the raw
% image from the DoFP camera.
%
% Input:
% Iraw : raw image from the DoFP camera
% appod : Boolean, if true, an appodisation with the hann function wiil be
% applied.
% padding : Boolean, if true, a zero-padding will be applied to the image
% in the Fourier space to retrieve the full resolution of the input image.
%
% Output:
% S : Image of the linear Stokes vector. (3 canaux)
% This code has been developped based on the method descirbed in the
% following article :
%{
@article{Tyo2009,
author = {J. Scott Tyo and Charles F. LaCasse and Bradley M. Ratliff},
journal = {Opt. Lett.},
keywords = {Ellipsometry and polarimetry; Polarimetry; Polarimetric imaging ; Fourier transforms; Point spread function; Polarimetric imaging; Polarization; Spatial frequency; Wave plates},
number = {20},
pages = {3187--3189},
publisher = {OSA},
title = {Total elimination of sampling errors in polarization imagery obtained with integrated microgrid polarimeters},
volume = {34},
month = {Oct},
year = {2009},
url = {http://www.osapublishing.org/ol/abstract.cfm?URI=ol-34-20-3187},
doi = {10.1364/OL.34.003187},
abstract = {Microgrid polarimeters operate by integrating a focal plane array with an array of micropolarizers. The Stokes parameters are estimated by comparing polarization measurements from pixels in a neighborhood around the point of interest. The main drawback is that the measurements used to estimate the Stokes vector are made at different locations, leading to a false polarization signature owing to instantaneous field-of-view (IFOV) errors. We demonstrate for the first time, to our knowledge, that spatially band limited polarization images can be ideally reconstructed with no IFOV error by using a linear system framework.},
}
%}

[nl,nc] = size(Iraw);
Iraw = double(Iraw);

% Making sur that the size of the image in both dimension can be divided by
% 4.
if not(floor(nl/4) == nl/4)
    Iraw = Iraw(1:end-2,:);
end
if not(floor(nc/4) == nc/4)
    Iraw = Iraw(:,1:end-2);
end
[nl,nc] = size(Iraw);


% Photometric calibration
t = [1.034, 1.014, 0.938, 1.014]; % relative transmission of the micro-polarizers. ( for the orientation [0, 45, 90, 135]°] )
Iraw(1:2:nl,1:2:nc) = Iraw(1:2:nl,1:2:nc)/t(3); % pixels haut-gauche, 90°
Iraw(1:2:nl,2:2:nc) = Iraw(1:2:nl,2:2:nc)/t(2); % pixels haut-droite, 45°
Iraw(2:2:nl,1:2:nc) = Iraw(2:2:nl,1:2:nc)/t(4); % pixels bas-gauche, 135°
Iraw(2:2:nl,2:2:nc) = Iraw(2:2:nl,2:2:nc)/t(1); % pixels bas-droite, 0°

% discret Fourier Transform :
If = fftshift(fft2(double(Iraw)));

% Appodisation matrix
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
    
    % We splite the fourier space to recover the 3 Stokes components (S0, S1+S2 et S1-S2)

    S0f = If(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc).*G / 4; % Information on S0
    S1pS2f = -4*cat(2,If(0.25*nl+1:0.75*nl,0.75*nc+1:nc),If(0.25*nl+1:0.75*nl,1:0.25*nc)).*G / 4; % Information on S1+S2
    S1mS2f = -4*cat(1,If(0.75*nl+1:nl,0.25*nc+1:0.75*nc),If(1:0.25*nl,0.25*nc+1:0.75*nc)).*G / 4; % Information on S1-S2
else
    % Zero padding is used to recover the full resolution
    S0f = zeros(size(Iraw));
    S1pS2f = zeros(size(Iraw));
    S1mS2f = zeros(size(Iraw));
    S0f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = If(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc).*G; % Information on S0
    S1pS2f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = -4*cat(2,If(0.25*nl+1:0.75*nl,0.75*nc+1:nc),If(0.25*nl+1:0.75*nl,1:0.25*nc)).*G; % Information on S1+S2
    S1mS2f(0.25*nl+1:0.75*nl,0.25*nc+1:0.75*nc) = -4*cat(1,If(0.75*nl+1:nl,0.25*nc+1:0.75*nc),If(1:0.25*nl,0.25*nc+1:0.75*nc)).*G; % Information on S1-S2
end

% Inverse Fourier transforms to retrieve the components : S0, S1+S2 et S1-S2
S0 = real(ifft2(fftshift(S0f))) * 2;
S1pS2 = real(ifft2(fftshift(S1pS2f)));
S1mS2 = real(ifft2(fftshift(S1mS2f)));

% Then S1 and S2 are retrieved
S1 = (S1pS2 + S1mS2)/2;
S2 = (S1pS2 - S1mS2)/2;

% We assemble the Stokes vector in the 3rd dimension of the image
S = cat(3, S0, S1, S2);

end