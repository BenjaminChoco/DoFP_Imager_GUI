function S = Raw2Stokes_LocalSP(Iraw, Wt)

% Function dedicated to determine the Stokes vector image from the raw
% image of the linear DoFP camera.

% Input:
% Iraw : raw image from the DoFP camera (size(Dx,Dy))
% Wt : Pseudo inverse of the measurement matrix used for the calculation of S from the
% intensities.

% Output:
% S : Image of the linear Stokes vector. (size(Dx/2,Dy/2,3))

% Adjusting the size of the measurement matrix (in the linear case, the
% fourth line is not needed)
K = size(Wt,1);
if K == 4
    Wt = Wt(1:3,:);
end

% Size of the images
[Dy, Dx] = size(Iraw);

% SHaping the datafor the vectorial computation
[I0, I45, I90, I135] = SeparPolar(double(Iraw));
Icat = reshape(cat(3, I0, I45, I90, I135),[Dx*Dy/4,4]);
Iv = permute(Icat, [2,1]);

% Inversion of all super-pixels at once
S = Wt*Iv;

% Reshaping into an image
S = permute(reshape(S, [3,Dy/2, Dx/2]), [2,3,1]);

end