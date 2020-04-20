%% GUI for the display of DoFP polarimétric images 

function DofpImager_gui

%% Paramèters of the interface color
DarkWindow = [0.1, 0.1, 0.1];
DarkBackground = [0.2, 0.2, 0.2];
DarkForeground = [0.8, 0.8, 0.8];

%% Oppening the image and its parameters :

% Path to the image and load of Iraw:
root_dir = "C:\Users\Benjamin\Desktop\CamData\Tests\Lampe_Iraw_1";
Iraw = load(root_dir);
Iraw = Iraw.Iraw;

% Initial correction of the DSNU
Ioffset = load('DSNU_20ms_ND.mat');
Ioffset = Ioffset.Ioffset;
I = double(Iraw) - Ioffset;

% Size of the images
Dx = 2448;
Dy = 2048;

%% Creation of the window

window = figure( 'Name', 'DoFP Imager GUI', ...
            'Units', 'normalized',...
            'OuterPosition', [0,0,1,1]);

hbox1 = uix.HBox( 'Parent', window, 'BackgroundColor', DarkBackground, 'Units', 'normalized');

vbox1 = uix.VBox( 'Parent', hbox1, 'Padding', 5 ,...
    'BackgroundColor', DarkWindow,...
    'Units', 'normalized', 'Position', [0,0,0.2,1]);

% Creation of a popup menu to choose the parameter to display
hpopup = uicontrol('Parent', vbox1,'Style','popupmenu',...
           'String',{'Mosaique', 'DOLP', 'AOP', 'Raw', 'S0'},...
           'Callback',@popup_menu_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);  

% Creation of the text box requesting te link to the polarimetric
% image
hpath  = uicontrol('Parent', vbox1,'Style','Edit',...
    'String','C:\Users\Benjamin\Desktop\CamData\Tests\Lampe_Iraw_1',...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
         
% Creation of the button to load the image
hload    = uicontrol('Parent', vbox1,'Style','pushbutton',...
             'String','load',...
             'Callback',@loadbutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
         
% Creaction of the 'axes' which will receive the image to display
axIm = axes('Parent', uicontainer('Parent', hbox1,'BackgroundColor', DarkWindow), 'Units', 'normalized');


h = imagesc(I, 'Parent', axIm);
colormap gray
axis equal
colorbar(axIm, 'Color', DarkForeground)
axis off

set( hbox1, 'Widths', [200 -1], 'Spacing', 5 );


%% Loading the polarimétric calibration matrix : Wt_sparse (pseudo inverse
% of W)
g = 0.37; % gain of the caméra (en ADU/e-)
Wt_sparse = load('Wt_sparse');
Wt_sparse = Wt_sparse.Wt_sparse ./g;


%% Functions 


function popup_menu_Callback(source,eventdata) 
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





function loadbutton_Callback(source,eventdata)
    % Path to the image and load of Iraw:
    root_dir = hpath.String;
    Iraw = load(root_dir);
    Iraw = Iraw.Iraw;
end


end