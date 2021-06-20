classdef remoteClass < obs.LAST_Handle
    % a bare bone pointer to a class object, of whichever type, living in a
    %  remote Matlab session, with which we communicate with a Messenger
    %  adequately estabilished (supposing also its dual return Messenger
    %  has been created remotely)
    
    properties
        Name        % the matlab variable name of the object we refer to, in the remote session
        Messenger   % the Messenger object which communicates with session hosting the remote class
        %IP
        %Port
        %Where char = 'caller';  % define where to execute the command: 'base' | 'caller'
    end
    
    methods
        
        function R=remoteClass(Remotename,varargin)
            % constructor assigning Name and Messenger from optional arguments
            % Usage:
            % R=remoteClass('CameraMsg',obs.util.Messenger('localhost',8081,8082));
            % R=remoteClass('CameraMsg','localhost',8081,8082)
            % The parameters are the Name, destinationIP, destinationPort, localPort
            
            if nargin>1
                if ischar(varargin{1})
                    % assume input is e.g., 'localhost',8081,8082
                    R.Messenger = obs.util.Messenger(varargin{:});
                    
                else
                    % assume user provided a messanger class object
                    R.Messenger = varargin{1};
                end
            end
              
            if nargin>0
                R.Name = Remotename;
            end
        end
        
    end
    
    methods (Static)
        function Port=construct_port_number(Type,Mount,Camera)
            % Construct a port number for device based on its Type, MountNumber and CameraNumber
            %
            % Port structure XYYZ
            % where X -- is type : Mounts 2, Camera 3, Focusers 4, Sensors
            % 5, Manager 6
            %       YY -- mount number 1..12
            %       Z  -- camera/focuser number 1..4, 1..2 for computer
            
            % Type Computer DeviceN
            % 2    01       00       - mount on computer 1
            % 3    01       04       - camera 4 on computer 1
            % 3    01       05       - camera 1 listener on computer 1
            % 4    01       04
            % 5    01       01
            % 6    00       00
            % 6    01       00
            
            if nargin<4
                Computer = [];
            end
            
            switch lower(Type)
                case 'mount'
                    TypeInd = 2;
                case 'camera'
                    TypeInd = 3;
                case 'focuser'
                    TypeInd = 4;
                case 'sensor'
                    TypeInd = 5;
                case 'computer'
                    TypeInd = 6;
                    % In this case Camera is ComputerNumber
                    if mod(Camera,2)==1
                        % odd computer number
                        Camera = 1;
                    else
                        Camera = 2;
                    end
                case 'manager'
                    TypeInd = 7;
                otherwise
                    error('Unknown Type option');
            end
            
            % port number for camera
            Port = 20000 + TypeInd.*1000 + Mount.*10 + Camera;
           
        end
            
    end
    
end