classdef LAST_Handle < handle
     
    properties (Hidden)
        Verbose=1; % textual verbosity. 0=suppress, 1=report info, 2=blabber
        Config     % struct of all fields read from the configuration, including those which are only informative 
    end
    
    properties (Hidden, GetAccess = public, SetAccess = protected)
        Id char; % a free text logical label, like '1_2_3' (for e.g. pier 1, mount 2, camera 3)
        PhysicalId char; % a physical identifier for the device (if applicable), like a serial number, or the connection port name
        LastError char;  % The last error message
    end
    
    methods(Access = ?obs.LAST_Handle)
        % the definitions are here instead than in separate files in a private/
        %  folder: so all subclasses which inherit from LAST_Handle can use
        %  them, otherwise not
        
        function report(N,msg)
            % verbose reporting (to be replaced by a proper call to
            %  AstroPack logger), like N.LogFile.write(msg)
            if N.Verbose
                fprintf(msg)
            end
        end

        function reportError(I,msg)
            % report on stdout and set LastError, with the same argument
            I.LastError=msg;
            I.report([msg,'\n'])
        end

    end
        
end

