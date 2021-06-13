function [ConfigStruct,ConfigFileNameLogical]=getConfigStruct(Obj,Address,ConfigBaseName,PhysicalKeyName)
% read configuration (logical and physical) file into
% ConfigStruct.
% Description: Read the logical configuration file, the
%              physical configuration file and the mount onfig file, and:
%              store it in ConfigStruct
%              To update the properties in the object according
%              to properties in the Config file use:
%              updatePropFromConfig
%              Mount config will be read into M.ConfigMount
% Input  : - Mount object
%          - This can be:
%            1. A mount address which is a vector of
%               [NodeNumber, MountNumber]
%            2. A mount configuration file name (string).
%            3. Empty [default]. In this case, some default
%               values will be used.
%          - ConfigBaseName. Default is 'config.camera'.
%          - Keyword in the logical configuration under which
%            the physical device name reside.
%            If this is not provided than will not read the
%            physical device config.
% Output : - Merged Structure of logical and physical config.
%          - Logical config file name.

    if nargin<4
        PhysicalKeyName = [];
        if nargin<3
            ConfigBaseName = 'config.camera';
            if nargin<2
                Address = [];
            end
        end
    end

    if isempty(Address)
        ConfigStruct          = struct();
        ConfigFileNameLogical = '';
    else

        % read the configuratin file
        if ischar(Address)
            ConfigFileNameLogical = Address;
        else
            switch numel(Address)
                case 1
                    ConfigFileNameLogical = sprintf('%s_%d.txt',ConfigBaseName,Address);
                case 2
                    ConfigFileNameLogical = sprintf('%s_%d_%d.txt',ConfigBaseName,Address);
                case 3
                    ConfigFileNameLogical = sprintf('%s_%d_%d_%d.txt',ConfigBaseName,Address);
                otherwise
                    % no config file
                    ConfigFileNameLogical = [];
            end
        end
        Obj.Config = ConfigFileNameLogical;


        if ~isempty(Obj.Config)
            ConfigLogical = configfile.read_config(Obj.Config);

            if ~isempty(PhysicalKeyName)
                % read the physical name - e.g., CameraName
                PhysicalName           = ConfigLogical.(PhysicalKeyName);
                ConfigFileNamePhysical = sprintf('config.%s.txt',PhysicalName);
                ConfigPhysical         = Obj.loadConfiguration(ConfigFileNamePhysical, false);

                % merge with ConfigLogical
                ConfigStruct = tools.struct.mergeStruct(ConfigLogical,ConfigPhysical);
            else
                ConfigStruct = ConfigLogical;
            end
        end
    end

end
