function I = refresh_display(Iraw, display_type, method, Wt_sparse, Wt, DoT, h)
    % Function to refresh the display of the image.
    if DoT
        if strcmp(display_type,'mos') % Choice of a 4D mosaic display
            I = MosaicPolar(Iraw);
            colormap gray

        elseif strcmp(display_type,'dolp') % Choice of DoLP display
            S = dot_SparseInv(Iraw, Wt_sparse);
            I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
            I(I>1) = 1;
            I(I<0) = 0;
            colormap parula

        elseif strcmp(display_type,'aop') % Choice of AoP display
            S = dot_SparseInv(Iraw, Wt_sparse);
            I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
            colormap hsv

        elseif strcmp(display_type,'raw') % Choice of RAW display
            I = Iraw(:,:,1); % Raw image without any process.
            colormap gray

        elseif strcmp(display_type,'S0') % Choice of S0 display
            S = dot_SparseInv(Iraw, Wt_sparse);
            I = S(:,:,1);
            colormap parula
            
        elseif strcmp(display_type,'hsv')
            S = dot_SparseInv(Iraw, Wt_sparse);
            DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
            DoLP(DoLP>1) = 1;
            DoLP(DoLP<0) = 0;

            AoP = pi + Stokes2AoP(S(:,:,2),S(:,:,3));

            Hue = AoP/max(max(AoP));
            Sat = DoLP;
            Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);

            HSV = cat(3,Hue,Sat,Val);
            I = hsv2rgb(HSV);
        end
    else
        if strcmp(display_type,'mos') % Choice of a 4D mosaic display
            I = MosaicPolar(Iraw);
            colormap gray

        elseif strcmp(display_type,'dolp') % Choice of DoLP display
            S = Raw2Stokes(Iraw, method, Wt_sparse, Wt);
            I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
            I(I>1) = 1;
            I(I<0) = 0;
            
            colormap parula

        elseif strcmp(display_type,'aop') % Choice of AoP display
            S = Raw2Stokes(Iraw, method, Wt_sparse, Wt);
            I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
            colormap hsv

        elseif strcmp(display_type,'raw') % Choice of RAW display
            I = Iraw; % Raw image without any process.
            colormap gray

        elseif strcmp(display_type,'S0') % Choice of RAW display
            S = Raw2Stokes(Iraw, method, Wt_sparse, Wt);
            I = S(:,:,1);
            colormap parula
            
        elseif strcmp(display_type,'Rq') % Choice of Rq display
            Rq = Pol2Rq(Iraw);
            I = Rq;
            colormap jet
            
        elseif strcmp(display_type,'hsv')
            S = Raw2Stokes(Iraw, method, Wt_sparse, Wt);
            DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
            DoLP(DoLP>1) = 1;
            DoLP(DoLP<0) = 0;

            AoP = pi/2 + Stokes2AoP(S(:,:,2),S(:,:,3));

            Hue = AoP/pi;
            Sat = DoLP/max(DoLP(:));
%             Sat = ones(size(DoLP));
%             Val = DoLP;
            Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);

            HSV = cat(3,Hue,Sat,Val);
            I = hsv2rgb(HSV);
        end
    end
    
    set(h,'CData',I) % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    set(h,'XData',[1,2448])
    set(h,'YData',[1,2048])

    
end