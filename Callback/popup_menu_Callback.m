% function popup_menu_Callback(source,eventdata)
% % Function responding to the callback of the popupmenu from gui.
% % Enables to change the polarimetric parameter to display with the GUI.
% 
% 
%     % Determine the selected data set.
%     str = get(source, 'String');
%     val = get(source,'Value');
%     % Set current data to the selected data set.
%     switch str{val}
%     case 'Mosaique' % Choice of a 4D mosaic display
%         display_type = 'mos';
%         I = MosaicPolar(Iraw);
%         colormap gray
% 
%     case 'DOLP'
%         display_type = 'dolp';
%         [I0, I45, I90, I135] = SeparPolar(double(Iraw));
%         Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
%         I_sparse = Isparse';
%         S_sparse = Wt_sparse*I_sparse(:);
%         S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
%         I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
%         I(I>1) = 1;
%         I(I<0) = 0;
%         colormap gray
% 
%     case 'AOP' % Choice of AoP display
%         display_type = 'aop';
%         [I0, I45, I90, I135] = SeparPolar(double(Iraw));
%         Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
%         I_sparse = Isparse';
%         S_sparse = Wt_sparse*I_sparse(:);
%         S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
%         I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
%         colormap hsv
% 
%     case 'Raw' % Choice of RAW display
%         display_type = 'raw';
%         I = Iraw; % Raw image without any process.
%         colormap gray
%         
%     case 'S0' % Choice of RAW display
%         display_type = 'S0';
%         [I0, I45, I90, I135] = SeparPolar(double(Iraw));
%         Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
%         I_sparse = Isparse';
%         S_sparse = Wt_sparse*I_sparse(:);
%         S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
%         I = S(:,:,1);
%         colormap gray
%     end
%     h.CData = I; % Update of the image with the handler of the display function 'imshow'.
%     drawnow() % Used to refresh the display.
%     h.XData = [1,2448];
%     h.YData = [1,2048];
% end