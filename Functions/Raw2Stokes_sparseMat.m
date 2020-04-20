function S = Raw2Stokes_sparseMat(Iraw, Wt_sparse)

% Function dedicated to determine the Stokes vector image from the raw
% image from the DoFP camera.

% Input:
% Iraw : raw image from the DoFP camera
% Wt_sparse : Sparse matrix used for the calculation of S from the
% intensities.

% Output:
% S : Image du vecteur de Stokes dans la scène. (3 canaux)


% Size of the images
Dx = 2448;
Dy = 2048;

[I0, I45, I90, I135] = SeparPolar(double(Iraw));
Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
I_sparse = Isparse';
S_sparse = Wt_sparse*I_sparse(:);
S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);


end