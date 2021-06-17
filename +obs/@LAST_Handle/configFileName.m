function f=configFileName(L,sublabel)
% build the canonical name for the yml configuration file, from class
%  properties (with the class subdirectory, but without the general config directory path).
% Example:  C=obs.camera('1_1_2')
%           C.configFileName('connect') --> 'obs.camera/obs.camera.1_1_2.connect.yml'
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
    f=fullfile(class(L), [class(L) a b '.yml']);
