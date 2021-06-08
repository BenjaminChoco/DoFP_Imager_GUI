function S = dot_SparseInv(Idot, Wt_sparse)

% Function dedicated to determine the Stokes vector image from the images
% of dot imager.

% Input:
% Idot : 4 images stacked on 3rd dimesions : [I0, I45, I90, I135]
% Wt_sparse : Sparse matrix used for the calculation of S from the
% intensities.

% Output:
% S : Image of the Stokes vector. (3 canaux)

% Size of the images
[Dy, Dx] = size(Idot(:,:,1));

I0 = double(Idot(:,:,1));
I45 = double(Idot(:,:,2));
I90 = double(Idot(:,:,3));
I135 = double(Idot(:,:,4));
Isparse = reshape(cat(3, I90, I45, I135, I0),[Dx*Dy,4]);
I_sparse = Isparse';
S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
S = permute(reshape(S_sparse,[3,Dy,Dx]),[2,3,1]);



end