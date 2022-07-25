function popup_method_Callback(source,eventdata) 
    % Callback function for the choice if the inverting method in the
    % corresponding menu.
    
    % Load global variables from the handles of hFig
    fig = get(get(get(source,'parent'),'parent'),'parent') ;
    handles = guidata(fig) ;
    
    Iraw = getappdata(handles.hFigure,'Iraw') ;
    Display_type = getappdata(handles.hFigure,'Display_type') ;
    method = getappdata(handles.hFigure,'method') ;
    Wt = getappdata(handles.hFigure,'Wt') ;
    DoT = getappdata(handles.hFigure,'DoT') ;
    h = getappdata(handles.hFigure,'h') ;
    
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source, 'Value');
    
    % Set current data to the selected data set.
    switch str{val}
        case 'Fourier'
            method = str{val};
        case 'LocalSP'
            method = str{val};
    end
    I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
    
    % Update global variables
    setappdata(handles.hFigure, 'method', method);
    setappdata(handles.hFigure, 'I', I);
end