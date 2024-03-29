function loadbutton_Callback(source,eventdata)
    % Function that drive the text entry for the path of Iraw.
    % It loads the image Iraw from the given path.
    
    % Load gloabl variables from the handles of hFig
    fig = get(get(get(source,'parent'),'parent'),'parent');
    handles = guidata(fig);
    
    Display_type = getappdata(handles.hFigure,'Display_type') ;
    method = getappdata(handles.hFigure,'method') ;
    Wt = getappdata(handles.hFigure,'Wt') ;
    DoT = getappdata(handles.hFigure,'DoT') ;
    h = getappdata(handles.hFigure,'h') ;
    hpopup_method = getappdata(handles.hFigure,'hpopup_method') ;
    hpath_folder = getappdata(handles.hFigure,'hpath_folder') ;
    hpath_name = getappdata(handles.hFigure,'hpath_name') ;
    
	% Loading the image
    root_dir = strcat(hpath_folder.String, '\', hpath_name.String);
    Iraw = load(root_dir);
    Iraw = double(getfield(Iraw, cell2mat(fieldnames(Iraw))));
    
    [nl, nc, c] = size(Iraw);
    if c == 1
        DoT = false;
        hpopup_method.Enable = 'On';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
    elseif c == 4
        DoT = true;
        hpopup_method.Enable = 'Off';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
    end
    Dx = nl;
    Dy = nc;
    
    % Update global variables
    setappdata(handles.hFigure, 'Dx', Dx);
    setappdata(handles.hFigure, 'Dy', Dy);
    setappdata(handles.hFigure, 'Iraw', Iraw);size(Iraw)
    setappdata(handles.hFigure, 'I', I);
    setappdata(handles.hFigure, 'DoT', DoT);
end