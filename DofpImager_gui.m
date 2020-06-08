%% GUI for the display of DoFP polarimétric images 

function DofpImager_gui

%% Paramèters of the interface color
DarkWindow = [0.1, 0.1, 0.1];
DarkBackground = [0.2, 0.2, 0.2];
DarkForeground = [0.8, 0.8, 0.8];

%% Oppening the image and its parameters :

% Initial correction of the DSNU
Ioffset = load('DSNU_20ms_ND.mat');
Ioffset = double(Ioffset.Ioffset);
% I = double(Iraw) - Ioffset;

% Size of the images
Dx = 2448;
Dy = 2048;

Iraw = NaN(Dx,Dy);

%% Loading the polarimétric calibration matrix : Wt_sparse (pseudo inverse
% of W)
g = 0.37; % gain of the caméra (en ADU/e-)
Wt_sparse = load('Wt_sparse');
Wt_sparse = Wt_sparse.Wt_sparse ./g;

%% Creation of the window

window = figure( 'Name', 'DoFP Imager GUI', ...
            'Units', 'normalized',...
            'OuterPosition', [0,0,1,1]);

hbox1 = uix.HBox( 'Parent', window, 'BackgroundColor', DarkBackground, 'Units', 'normalized');

vbox1 = uix.VBox( 'Parent', hbox1, 'Padding', 5 ,...
    'BackgroundColor', DarkWindow,...
    'Units', 'normalized', 'Position', [0,0,0.2,1]);

% Creation of a popup menu to choose the parameter to display
hpopup_display = uicontrol('Parent', vbox1,'Style','popupmenu',...
           'String',{'Mosaique', 'DOLP', 'AOP', 'Raw', 'S0', 'HSV'},...
           'Callback', {@popup_menu_Callback},... %, Iraw, Wt_sparse
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

% Creation of a popup menu to choose the method of inverting
hpopup_method = uicontrol('Parent', vbox1,'Style','popupmenu',...
           'String',{'SparseMat', 'Fourier'},...
           'Callback', {@popup_method_Callback},... %, Iraw, Wt_sparse
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


h = imagesc(Iraw, 'Parent', axIm);
colormap gray
axis equal
colorbar(axIm, 'Color', DarkForeground)
axis off

set( hbox1, 'Widths', [200 -1], 'Spacing', 5 );

%% Initialization of variables :

method = 'SparseMat';
Display_type = 'mos';
refresh_display(Iraw, Display_type, method, Wt_sparse)



%% Functions 

%
function popup_menu_Callback(source,eventdata) 
    % Function that drives the popup menu for the selection of the display.
    % 
    
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source,'Value');
    % Set current data to the selected data set.
    switch str{val}
    case 'Mosaique' % Choice of a 4D mosaic display
        Display_type = 'mos';
        refresh_display(Iraw, Display_type, method, Wt_sparse)

    case 'DOLP' % Choice of DoLP display
        Display_type = 'dolp';
        refresh_display(Iraw, Display_type, method, Wt_sparse)

    case 'AOP' % Choice of AoP display
        Display_type = 'aop';
        refresh_display(Iraw, Display_type, method, Wt_sparse)

    case 'Raw' % Choice of RAW display
        Display_type = 'raw';
        refresh_display(Iraw, Display_type, method, Wt_sparse)
        
    case 'S0' % Choice of RAW display
        Display_type = 'S0';
        refresh_display(Iraw, Display_type, method, Wt_sparse)
    case 'HSV'
        Display_type = 'hsv';
        refresh_display(Iraw, Display_type, method, Wt_sparse)
    end
end
%}

function popup_method_Callback(source,eventdata) 
    % Callback function for the choice if the inverting method in the
    % corresponding menu.
    
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source,'Value');
    % Set current data to the selected data set.
    switch str{val}
        case 'SparseMat'
            method = str{val};
        case 'Fourier'
            method = str{val};
    end
    refresh_display(Iraw, Display_type, method, Wt_sparse)
    
end
    


function loadbutton_Callback(source,eventdata)
    % Function that drive the text entry for the path of Iraw.
    % It loads the image Iraw from the given path.
    root_dir = hpath.String;
    Iraw = load(root_dir);
    Iraw = double(Iraw.Iraw) - Ioffset;
    refresh_display(Iraw, Display_type, method, Wt_sparse)
end


function refresh_display(Iraw, display_type, method, Wt_sparse)
    % Function to refresh the display of the image.
    
    if strcmp(display_type,'mos') % Choice of a 4D mosaic display
        I = MosaicPolar(Iraw);
        colormap gray

    elseif strcmp(display_type,'dolp') % Choice of DoLP display
        S = Raw2Stokes(Iraw, method, Wt_sparse);
        I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        I(I>1) = 1;
        I(I<0) = 0;
        colormap parula

    elseif strcmp(display_type,'aop') % Choice of AoP display
        S = Raw2Stokes(Iraw, method, Wt_sparse);
        I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
        colormap hsv

    elseif strcmp(display_type,'raw') % Choice of RAW display
        I = Iraw; % Raw image without any process.
        colormap gray
        
    elseif strcmp(display_type,'S0') % Choice of RAW display
        S = Raw2Stokes(Iraw, method, Wt_sparse);
        I = S(:,:,1);
        colormap parula
    elseif strcmp(display_type,'hsv')
        S = Raw2Stokes(Iraw, method, Wt_sparse);
        DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        DoLP(DoLP>1) = 1;
        DoLP(DoLP<0) = 0;
        
        AoP = Stokes2AoP(S(:,:,2),S(:,:,3));
        
        Hue = AoP/max(max(AoP));
        Sat = DoLP;
        Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);

        HSV = cat(3,Hue,Sat,Val);
        I = hsv2rgb(HSV);
    end
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
    
end

end