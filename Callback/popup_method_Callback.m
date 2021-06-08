function popup_method_Callback(source,eventdata) 
    % Callback function for the choice if the inverting method in the
    % corresponding menu.
    
    % Load gloabl variables from the handles of hFig
    fig = get(get(get(source,'parent'),'parent'),'parent') ;
    handles = guidata(fig) ;
    
    Iraw = getappdata(handles.hFigure,'Iraw') ;
    Display_type = getappdata(handles.hFigure,'Display_type') ;
    method = getappdata(handles.hFigure,'method') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    DoT = getappdata(handles.hFigure,'DoT') ;
    h = getappdata(handles.hFigure,'h') ;
    
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source, 'Value');
    
    % Set current data to the selected data set.
    switch str{val}
        case 'SparseMat'
            method = str{val};
        case 'Fourier'
            method = str{val};
    end
    I = refresh_display(Iraw, Display_type, method, Wt_sparse, DoT, h);
    
    setappdata(handles.hFigure, 'method', method);
    setappdata(handles.hFigure, 'I', I);
end