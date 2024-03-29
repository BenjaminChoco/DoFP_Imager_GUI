function S = Raw2Stokes(Iraw, method, Wt)
    % Function to convert the Raw image into an image of the linear Stokes
    % vector. It uses the function corresponding to the choice in the popup
    % menu dedicated to the choise of the method.
    if strcmp(method, 'Fourier')
        S = Raw2Stokes_Fourier(Iraw, true, true);
    elseif strcmp(method, 'LocalSP')
        S = Raw2Stokes_LocalSP(Iraw, Wt);
    end
end