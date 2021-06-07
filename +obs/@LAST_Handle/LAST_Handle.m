classdef LAST_Handle < handle
     
    properties (Hidden)
        Config         % name of the associated configuration file (searched in the configurations directory)
        ConfigStruct   % The configuration structure loaded from file
        Verbose=1;     % textual verbosity. 0=suppress, 1=report info, 2=blabber
    end
    
    properties (Hidden, GetAccess = public, SetAccess = protected)
        LastError='';  % The last error message
    end
    
    methods(Access = ?obs.LAST_Handle)
        % the definition is here instead than in separate files in a private/
        %  folder: so all subclasses which inherit from LAST_Handle can use
        %  them, otherwise not
        
        function report(N,msg)
            % verbose reporting (to be replaced by a proper call to
            %  Astropack logger)
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

