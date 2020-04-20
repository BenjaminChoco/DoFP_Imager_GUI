function Wt_sparse = Create_SparseMat()



v = @(q, phi) 0.5*[1 ,  q.*cos(2*phi), q*sin(2*phi)];
phi = [pi/2, pi/4, 3*pi/4, 0]'; % Angles de micropolariseurs (attention à l'ordre !)
% Calcule de la matrice W idéale :
W = NaN(4,3);
for i = 1:4
    Li = v(1,phi(i)); % On considère des pixels idéaux
    W(i,:) = Li(1:3);
end
W
Wt = pinv(W)

nl = 1024;
nc = 1224;
Ns = nl*nc;

tic
idx_i = NaN(1,nl*nc*3*4);
idx_j = NaN(1,nl*nc*3*4);
val_ij = NaN(1,nl*nc*3*4);
for i = 1:Ns
    [X,Y] = meshgrid(((i-1)*4+1):i*4,((i-1)*3+1):i*3);
    idx_i(((i-1)*12+1):i*12) =  X(:);
    idx_j(((i-1)*12+1):i*12) = Y(:);
    % Wt_ij = Wt_slide(:,:,i);
    Wt_ij = Wt;
    val_ij(((i-1)*12+1):i*12) = Wt_ij(:);
end
Wt_sparse = sparse(idx_j,idx_i,val_ij);
toc


end