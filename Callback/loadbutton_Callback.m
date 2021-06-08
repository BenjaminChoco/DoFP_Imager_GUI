function loadbutton_Callback(source,eventdata)
    % Function that drive the text entry for the path of Iraw.
    % It loads the image Iraw from the given path.
    
    % Load gloabl variables from the handles of hFig
    fig = get(get(get(source,'parent'),'parent'),'parent');
    handles = guidata(fig);
    
%     Iraw = getappdata(handles.hFigure,'Iraw') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    Display_type = getappdata(handles.hFigure,'Display_type') ;
    method = getappdata(handles.hFigure,'method') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    Wt = getappdata(handles.hFigure,'Wt') ;
    DoT = getappdata(handles.hFigure,'DoT') ;
    h = getappdata(handles.hFigure,'h') ;
    hpopup_method = getappdata(handles.hFigure,'hpopup_method') ;
    hpath_folder = getappdata(handles.hFigure,'hpath_folder') ;
    hpath_name = getappdata(handles.hFigure,'hpath_name') ;
    
    
    root_dir = strcat(hpath_folder.String, '\', hpath_name.String);
    Iraw = load(root_dir);
    Iraw = double(getfield(Iraw, cell2mat(fieldnames(Iraw))));
%     I = Iraw;
    [nl, nc, c] = size(Iraw);
    if c == 1
%         if (nl ~= Dx)||(nc ~= Dy)||DoT
%             Wt_sparse = Create_SparseMat(nc/2, nl/2);
%         end
        DoT = false;
        hpopup_method.Enable = 'On';
        I = refresh_display(Iraw, Display_type, method, Wt_sparse, Wt, DoT, h);
    elseif c == 4
%         if (nl ~= Dx)||(nc ~= Dy)||(~DoT)
%             Wt_sparse = Create_SparseMat(nc, nl);
%         end
        DoT = true;
        hpopup_method.Enable = 'Off';
        I = refresh_display(Iraw, Display_type, method, Wt_sparse, Wt, DoT, h);
    end
    Dx = nl;
    Dy = nc;
    
    setappdata(handles.hFigure, 'Dx', Dx);
    setappdata(handles.hFigure, 'Dy', Dy);
    setappdata(handles.hFigure, 'Iraw', Iraw);size(Iraw)
    setappdata(handles.hFigure, 'I', I);
    setappdata(handles.hFigure, 'DoT', DoT);
end