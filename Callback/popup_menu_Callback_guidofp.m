function popup_menu_Callback_guidofp(source,eventdata) 
    % Function that drives the popup menu for the selection of the display.
    
    % Load gloabl variables from the handles of hFig
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
    case 'Mosaique' % Choice of a mosaic display
        Display_type = 'mos';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);

    case 'DOLP' % Choice of DoLP display
        Display_type = 'dolp';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);

    case 'AOP' % Choice of AoP display
        Display_type = 'aop';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);

    case 'Raw' % Choice of RAW display
        Display_type = 'raw';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
        
    case 'S0' % Choice of RAW display
        Display_type = 'S0';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
        
    case 'Rq' % Choice of Rq display
        Display_type = 'Rq';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
        
    case 'H-S-V : AoP-DoLP-S0'
        Display_type = 'H-S-V : AoP-DoLP-S0';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
        
    case 'error_map'
        Display_type = 'error_map';
        I = refresh_display(Iraw, Display_type, method, Wt, DoT, h);
    end
    
    %Update Global variables
    setappdata(handles.hFigure, 'Display_type', Display_type);
    setappdata(handles.hFigure, 'I', I);
end