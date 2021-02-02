function loadConfiguration(X,name)
% read a configuration file from the canonical place, and assign to all
%  properties of the class which match keys in the configuration file the
%  values read from there
%
% usage: setConfiguration(name)
% 
%  the configuration values of the class are looked for into a file
%   name.txt. The name of the configuration file could be chosen opportunely
%   to match the physical name of the device being configured, or its place
%   and role.
% If name is omitted, the default name in the class property Config is used. If that is
%  empty, well, for the moment we search for unknown.txt...

if ~exist('name','var')
    if ~isempty(X.Config)
        name=X.Config;
    else
        % there should be a canonical way of determing it from the class object
        %  itself here. Like MountName, CameraName, etc.
        name='unknown';
    end
end

% look for a configuration file (name).txt
try
    keyvalue=configfile.read_config([name '.txt']);
catch
    keyvalue=struct();
end

p=fieldnames(keyvalue);
for i=1:length(p)
    try
        X.(p{i})=keyvalue.(p{i});
    catch
        % fail silently if the tag in the configuration file is not a
        %  property of the class in question
    end
end