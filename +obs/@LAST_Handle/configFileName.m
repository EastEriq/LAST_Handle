function f=configFileName(L,sublabel)
% build the canonical name for the yml configuration file, from class
%  properties (with the class subdirectory, but without the general config directory path).
% If sublabel='create', L.Id is used in the filename;
% if sublabel='connect', L.PhysicalId is used in the filename;
% if sublabel is anything else, sublabel is used verbatim.
%
% Example:  C=obs.camera('1_1_2')
%           C.configFileName('create') --> 'obs.camera/obs.camera.1_1_2.connect.yml'
    arguments
        L
        sublabel (1,:) char = ''
    end
 
    if isempty(sublabel)
        b='';
    else
        b=['.' sublabel];
    end
    switch sublabel
        case 'create'
            if isempty(L.Id)
                a='';
            else
                a=['.' L.Id];
            end
        case 'connect'
            if isempty(L.PhysicalId)
                a='';
            else
                a=['.' L.PhysicalId];
            end
        otherwise
            a='';
    end
    f=fullfile(class(L), [class(L) a b '.yml']);
