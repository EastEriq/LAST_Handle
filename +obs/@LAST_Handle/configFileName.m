function f=configFileName(L,sublabel)
% build the canonical name for the yml configuration file, from class
%  properties
    arguments
        L
        sublabel (1,:) char = ''
    end

    
    if isempty(L.Id)
        a='';
    else
        a=['.' L.Id];
    end
    if isempty(sublabel)
        b='';
    else
        b=['.' sublabel];
    end
    f=[class(L) a b '.yml'];
