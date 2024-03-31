function ChosenLogger=getLogger(L)
% a helper for the .reportXXX methods, to decide which logger is in use
    global DefaultLogger
    
    if isempty(DefaultLogger)
        DefaultLogger = MsgLogger();
    end
    if isprop(L, 'Logger') && ~isempty(L.Logger)
        ChosenLogger = L.Logger;
    else
        ChosenLogger = DefaultLogger;
    end
    % fprintf("Class(L): '%s', ChosenLogger: '%s'\n", class(L), class(ChosenLogger));
end
