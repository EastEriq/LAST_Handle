function f=configFileName(L,sublabel)
% build the canonical name for the yml configuration file, from class
%  properties (with the class subdirectory, but without the general config directory path).
% If sublabel='create', L.Id is used in the filename;
% If sublabel='createsuper', L.Id is used in the filename, but the
%                           superclass name is used as prefix
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
        case {'create','createsuper','destroy'}
            if isempty(L.Id)
                a='';
            else
                a=['.' L.Id];
            end
            m=metaclass(L);
            if strcmp(sublabel,'createsuper') && ~isempty(m.SuperclassList.Name)
            % prefer the superclass name as a prefix
                c=m.SuperclassList.Name;
                b='.create';
            else
                c=class(L);
            end
        case {'connect','disconnect'}
            if isempty(L.PhysicalId)
                a='';
            else
                a=['.' L.PhysicalId];
            end
            c=class(L);
        otherwise
            a='';
            c=class(L);
    end
    f=fullfile(c, [c a b '.yml']);
