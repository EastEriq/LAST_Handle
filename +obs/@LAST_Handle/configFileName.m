function f=configFileName(L,sublabel)
% build the canonical name for the yml configuration file, from class
%  properties (without the directory path).
% Example: obs.camera.configFileName('connect') --> 'obs.camera.1_1_2.connect.yml'
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
