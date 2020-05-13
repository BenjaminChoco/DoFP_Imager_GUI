%{
function popup_menu_Callback(source,eventdata,Iraw, Wt_sparse) 
    % Function that drives the popup menu for the selection of the display.
    % 
    
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source,'Value');
    % Set current data to the selected data set.
    switch str{val}
    case 'Mosaique' % Choice of a 4D mosaic display
        display_type = 'mos';
        I = MosaicPolar(Iraw);
        colormap gray

    case 'DOLP' % Choice of DoLP display
        display_type = 'dolp';
        S = Raw2Stokes_sparseMat(Iraw, Wt_sparse);
        I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        I(I>1) = 1;
        I(I<0) = 0;
        colormap gray

    case 'AOP' % Choice of AoP display
        display_type = 'aop';
        S = Raw2Stokes_sparseMat(Iraw, Wt_sparse);
        I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
        colormap hsv

    case 'Raw' % Choice of RAW display
        display_type = 'raw';
        I = Iraw; % Raw image without any process.
        colormap gray
        
    case 'S0' % Choice of RAW display
        display_type = 'S0';
        S = Raw2Stokes_sparseMat(Iraw, Wt_sparse);
        I = S(:,:,1);
        colormap gray
    end
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
end
%}