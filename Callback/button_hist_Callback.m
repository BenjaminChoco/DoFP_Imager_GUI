function button_hist_Callback(source,eventdata)
    % button_hist_Callback : Callback to display the histogram of the current
    % image.
    
    % Load gloabl variables from the handles of hFig
    fig = get(get(get(source,'parent'),'parent'),'parent') ;
    handles = guidata(fig) ;

    I = getappdata(handles.hFigure,'I') ;
    Display_type = getappdata(handles.hFigure,'Display_type') ;
    method = getappdata(handles.hFigure,'method') ;
    
    % Display the histogram of 'I' in a new Figure
    figure()
    histogram(I, 'DisplayStyle', 'stairs')
    title(strcat(Display_type, '  <', method, '>'))

end