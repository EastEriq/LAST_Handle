classdef LAST_Handle < handle
     
    properties (Hidden)
        Config         % name of the associated configuration file (searched in the configurations directory)
        ConfigStruct   % The configuration structure loaded from file
    end

    
        % Aux
    methods
        
        function [ConfigStruct,ConfigFileNameLogical]=getConfigStruct(Obj,Address,ConfigBaseName,PhysicalKeyName)
            %
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
                        ConfigStruct = Util.struct.mergeStruct(ConfigLogical,ConfigPhysical);
                    else
                        ConfigStruct = ConfigLogical;
                    end
                end
            end
            
        end
        
        function Obj=updatePropFromConfig(Obj,ListProp,ConfigStruct)
            % Update the properties in the Object according to their
            % value in ConfigStruct.
            % Input  : - An object (e.g., obs.camera object).
            %          - A cell array of properties to copy from the
            %            ConfigStruct to the object.
            %            E.g.,
            %            {'CameraType','CameraName','CameraModel'}
            %          - ConfigStruct: A structure containing the
            %            Config file content. If not provided, then will
            %            be taken from the Obj.ConfigStruct.
            if nargin<3
                ConfigStruct = Obj.ConfigStruct;
            end

            Nprop = numel(ListProp);
            for Iprop=1:1:Nprop
                %ListProp{Iprop}
                if isfield(ConfigStruct,ListProp{Iprop})
                    Obj.(ListProp{Iprop}) = ConfigStruct.(ListProp{Iprop});
                else
                    Obj.LogFile.writeLog(sprintf('Error: Propery %s was not found in ConfigStruct',ListProp{Iprop}));
                end
            end
        end
        
        function [Obj,OutStruct]=writePropToFile(Obj,ListProp,varargin)
            % write a list of Object properties into a status file
            % Input  : - An object
            %          - A cell array ocontaining the list of properties
            %          * ...,key,val,...
            %            'Path' - File path. Default is '~'.
            %            'FileName' - File name. Default is 'status.txt'.
            %            'WriteTimeTagJD' - Default is true.
            %            'WriteTimeTagStr' - Default is true.
            %            'Permission' - Write permission. Default is 'w'.
            %            'DiscardBeforeWriting' - Default is true.
            % Output : - An object.
            %          - A structure containing the printed properties.
            
            
            InPar = inputParser;
            addOptional(InPar,'Path','~');  
            addOptional(InPar,'FileName','status.txt');  
            addOptional(InPar,'WriteTimeTagJD',true);  
            addOptional(InPar,'WriteTimeTagStr',true);  
            addOptional(InPar,'Permission','a');  
            addOptional(InPar,'DiscardBeforeWriting','a');  
            parse(InPar,varargin{:});
            InPar = InPar.Results;
            
            FullFileName = sprintf('%s%s%s',InPar.Path,filesep,InPar.FileName);
            if InPar.DiscardBeforeWriting
                delete(FullFileName);
            end
            FID = fopen(FullFileName,InPar.Permission);
            JD = celestial.time.julday;
            if InPar.WriteTimeTagJD
                % write time tag
                OutStruct.TimeTagJD = JD;
                fprintf(FID,'TimeTagJD     : %22.16f : \n',OutStruct.TimeTagJD);
            end
            if InPar.WriteTimeTagStr
                % write time tag
                StrDate = convert.time(JD,'JD','StrDate');
                OutStruct.TimeTagStr = StrDate;
                fprintf(FID,'TimeTagStr    : %s : \n',OutStruct.TimeTagStr{1});
            end
            
            Nprop = numel(ListProp);
            for Iprop=1:1:Nprop
                OutStruct.(ListProp{Iprop}) = Obj.(ListProp{Iprop});
                if ischar(OutStruct.(ListProp{Iprop}))
                    fprintf(FID,'%s     : %s : \n',ListProp{Iprop},OutStruct.(ListProp{Iprop}));
                elseif isnumeric(OutStruct.(ListProp{Iprop})) && numel(OutStruct.(ListProp{Iprop}))==1
                    fprintf(FID,'%s     : %22.16f : \n',ListProp{Iprop},OutStruct.(ListProp{Iprop}));
                else
                    error('Proprty must contain a string or a single elemet numeric array');
                end
            end
            fclose(FID);
            
            
            
            
        end
        
        
        % need to retire
        function [ConfigStruct,ConfigLogical,ConfigPhysical,ConfigFileNameLogical,ConfigFileNamePhysical]=readConfig(Obj,Address,ConfigBaseName,PhysicalKeyName)
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
            %          - Structure of the logical configuration 
            %          - Structure of the physical configuration 
            %          - Logical config file name
            %          - Physical config file name
            
            if nargin<4
                PhysicalKeyName = [];
                if nargin<3
                    ConfigBaseName = 'config.camera';
                    if nargin<2
                        Address = [];
                    end
                end
            end
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
            
            ConfigLogical  = [];
            ConfigPhysical = [];
            ConfigFileNamePhysical = [];
            if ~isempty(Obj.Config)
                
                ConfigLogical = Obj.loadConfiguration(Obj.Config, false);
                
                if ~isempty(PhysicalKeyName)
                    % read the physical name - e.g., CameraName
                    PhysicalName           = ConfigLogical.(PhysicalKeyName);
                    ConfigFileNamePhysical = sprintf('config.%s.txt',PhysicalName);
                    ConfigPhysical         = Obj.loadConfiguration(ConfigFileNamePhysical, false);
                    
                    % merge with ConfigLogical
                    ConfigStruct = Util.struct.mergeStruct(ConfigLogical,ConfigPhysical);
                else
                    ConfigStruct = ConfigLogical;
                end
                
                %Obj.ConfigStruct = ConfigStruct;
                
                % read mount config
                %ConfigMountFileName = sprintf('config.mount_%d_%d.txt',Address(1:2));
                %Obj.ConfigStruct = Obj.loadConfiguration(ConfigMountFileName, false);
                
            end
            
            
            
            
        end
            
        
                
        
    end
    
    
    
end

