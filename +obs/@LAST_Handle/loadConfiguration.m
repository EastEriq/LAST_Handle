function keyvalue=loadConfiguration(X,Name,SetProp)
% read a configuration file from the canonical place, and assign to all
%  properties of the class which match keys in the configuration file the
%  values read from there
%
% Input  : - LAST_Handle object
%          - Configuration file name
%            If empty, then use X.Config
%          - A logical flag indicating if to change properties in the
%            object X according to the configuration file.
%            Default is false.
%

% usage: Config=setConfiguration(name,SteProp)
%
% Config is a structure containing the configuration file values
%
%  the configuration values of the class are looked for into a file
%   name.txt. The name of the configuration file could be chosen opportunely
%   to match the physical name of the device being configured, or its place
%   and role.
%  SetProp is a ;logical flag indicating if to set the properties of the
%  object according to those read from the configuration file.
%  Default is true.
%
% If name is omitted, the default name in the class property Config is used. If that is
%  empty, well, for the moment we search for unknown.txt...

if nargin<3
    SetProp = false;
    if nargin<2
        Name = [];
    end
end

if isempty(Name)
    Name = X.Config;
end

    
    
% if ~exist('name','var')
%     if ~isempty(X.Config)
%         name=X.Config;
%     else
%         % there should be a canonical way of determing it from the class object
%         %  itself here. Like MountName, CameraName, etc.
%         name='unknown';
%     end
% end

% look for a configuration file (name).txt
try
    keyvalue=configfile.read_config(Name); %[name '.txt']);
catch
    keyvalue=struct();
end

if SetProp
    PropName=fieldnames(keyvalue);
    for I=1:length(PropName)
        try
            X.(PropName{I})=keyvalue.(PropName{I});
        catch
            % fail silently if the tag in the configuration file is not a
            %  property of the class in question
        end
    end
end