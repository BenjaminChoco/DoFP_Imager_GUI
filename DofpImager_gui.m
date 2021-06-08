%% GUI for the display of DoFP polarimétric images 
clear variables

%% Paramèters of the interface color
DarkWindow = [0.1, 0.1, 0.1];
DarkBackground = [0.2, 0.2, 0.2];
DarkForeground = [0.8, 0.8, 0.8];

%% Oppening the image and its parameters :

% Size of the images
Dx = 2448;
Dy = 2048;

Iraw = NaN(Dy,Dx);
I = NaN(Dy,Dx);
DoT = false;

%% Loading the polarimétric calibration matrix : Wt_sparse (pseudo inverse
% of W)

Wt_sparse = load('Wt_sparse');
% Wt_sparse = Create_SparseMat(Dy, Dx);
Wt_sparse = Wt_sparse.Wt_sparse;

%% Creating an average Wt matrix (pseudo inverse of W) from calibration values

% Fonction v : fonction d'une des lignes de la matrice W, il faudra
% ensuite concaténé les différentes lignes
v = @(t, q, phi) 0.5*t*[1 ,  q.*cos(2*phi), q.*sin(2*phi)];

% Paramètres du capteur :
phi = [0, pi/4, pi/2, 3*pi/4]'; % Angles de micropolariseurs (attention à l'ordre !)
q = [0.95, 0.94, 0.945, 0.93]; % diattenuations moyennes des micropolariseurs
t = [1.034, 1.014, 0.938, 1.014]; % transmission moyenne des micropolariseurs

% Calcule de la matrice W idéale :
W = NaN(4,3);
for i = 1:4
    Li = v(t(i),q(i),phi(i)); % On considère des pixels idéaux
    W(i,:) = Li(1:3);
end

Wt = pinv(W);


%% Creation of the window

hFig = figure( 'Name', 'DoFP Imager GUI', ...
            'Units', 'normalized',...
            'Tag', 'hFigure', ...
            'OuterPosition', [0,0,1,1]);

hbox1 = uix.HBox( 'Parent', hFig, 'BackgroundColor', DarkBackground, 'Units', 'normalized');

vbox1 = uix.VBox( 'Parent', hbox1, 'Padding', 5 ,...
    'BackgroundColor', DarkWindow,...
    'Units', 'normalized', 'Position', [0,0,0.2,1]);

% Creation of a popup menu to choose the parameter to display
uicontrol('Parent', vbox1,'Style','popupmenu',...
           'String',{'Mosaique', 'DOLP', 'AOP', 'Raw', 'S0', 'Rq', 'HSV'},...
           'Callback', {@popup_menu_Callback_guidofp},... %, Iraw, Wt_sparse
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

% Creation of a popup menu to choose the method of inverting
hpopup_method = uicontrol('Parent', vbox1,'Style','popupmenu',...
           'String',{'LocalSP', 'SparseMat', 'Fourier'},...
           'Callback', {@popup_method_Callback},... %, Iraw, Wt_sparse
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);         

% Creation of a popup menu to choose the method of inverting
uicontrol('Parent', vbox1,'Style','pushbutton',...
           'String',{'Plot Histogram'},...
           'Callback', {@button_hist_Callback},... %, Iraw, Wt_sparse
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground); 
         
% Creation of the text box requesting te link to the polarimetric
% image
hpath_folder  = uicontrol('Parent', vbox1,'Style','Edit',...
    'String','Data',...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

hpath_name  = uicontrol('Parent', vbox1,'Style','Edit',...
    'String','Scotch',...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
         
% Creation of the button to load the image
uicontrol('Parent', vbox1,'Style','pushbutton',...
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


%% Storage of global variables in the handle of hFig
handles = guihandles(hFig) ;
guidata(hFig,handles) ;

setappdata(handles.hFigure,'Dx',Dx) ;
setappdata(handles.hFigure,'Dy',Dy) ;
setappdata(handles.hFigure,'Iraw',Iraw) ;
setappdata(handles.hFigure,'I',I) ;
setappdata(handles.hFigure,'DoT',DoT) ;
setappdata(handles.hFigure,'Wt_sparse',Wt_sparse) ;
setappdata(handles.hFigure,'Wt',Wt) ;
setappdata(handles.hFigure,'method',method) ;
setappdata(handles.hFigure,'Display_type',Display_type) ;
setappdata(handles.hFigure,'h',h) ;

setappdata(handles.hFigure,'hpopup_method',hpopup_method) ;
setappdata(handles.hFigure,'hpath_folder',hpath_folder) ;
setappdata(handles.hFigure,'hpath_name',hpath_name) ;

