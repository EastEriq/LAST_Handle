classdef remoteClass < obs.LAST_Handle
    % a bare bone pointer to a class object, of whichever type, living in a
    %  remote Matlab session, with which we communicate with a Messenger
    %  adequately estabilished (supposing also its dual return Messenger
    %  has been created remotely)
    
    properties
        Name % the matlab variable name of the object we refer to, in the remote session
        Messenger % the Messenger object which communicates with session hosting the remote class
    end
    
    methods
        
        function R=remoteClass(remotename,messenger)
            % constructor assigning Name and Messenger from optional arguments
            %  if provided
            if nargin>1
                R.Messenger=messenger;
            end
            if nargin>0
                R.Name=remotename;
            end
        end
        
    end
    
end