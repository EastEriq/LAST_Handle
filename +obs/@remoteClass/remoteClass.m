classdef remoteClass < obs.LAST_Handle
    % a bare bone pointer to a class object, of whichever type, living in a
    %  remote Matlab session, with which we communicate with a Messenger
    %  adequately estabilished (supposing also its dual return Messenger
    %  has been created remotely)
    
    properties
        RemoteName  % the matlab variable name of the object we refer to, in the remote session
        Messenger   % the Messenger object which communicates with session hosting the remote class
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
                R.RemoteName = Remotename;
            end
        end
        
    end
    
end