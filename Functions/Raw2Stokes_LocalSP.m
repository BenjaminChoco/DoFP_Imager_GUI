function S = Raw2Stokes_LocalSP(Iraw, Wt)

% Function dedicated to determine the Stokes vector image from the raw
% image from the DoFP camera.

% Input:
% Iraw : raw image from the DoFP camera
% Wt : Matrix used for the calculation of S from the
% intensities.

% Output:
% S : Image du vecteur de Stokes dans la scène. (3 canaux)


% Size of the images
[Dy, Dx] = size(Iraw);

[I0, I45, I90, I135] = SeparPolar(double(Iraw));
Isparse = reshape(cat(3, I0, I45, I90, I135),[Dx*Dy/4,4]);
% I_sparse = Isparse';
% S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
% S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);

Iv = permute(Isparse, [2,1]);
S = NaN(3,Dx*Dy/4);

for n = 1:Dx*Dy/4
    S(:,n) = Wt*Iv(:,n);
end
S = permute(reshape(S, [3,Dy/2, Dx/2]), [2,3,1]);

end