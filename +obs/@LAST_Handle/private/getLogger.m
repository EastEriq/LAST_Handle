function ChosenLogger=getLogger(L)
% a helper for the .reportXXX methods, to decide which logger is in use
    global DefaultLogger
    if isempty(DefaultLogger)
        DefaultLogger = obs.api.ApiLogger('FilePath', 'no-location');
    end
    if isprop(L, 'Logger') && ~isempty(L.Logger)
        ChosenLogger = L.Logger;
    else
        ChosenLogger = DefaultLogger;
    end
