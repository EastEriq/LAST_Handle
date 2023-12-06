classdef LAST_Handle < handle
    % The Mother of al LAST classes, which provides some common properties,
    %  like .Id, .LastError, .Verbose, and some general methods, like
    %  .loadConfig, .displayProperties
     
    properties (Hidden)
        Verbose=1; % textual verbosity. 0=suppress, 1=report info, 2=blabber
        Config     % struct of all fields read from the configuration, including those which are only informative 
        Digest; % for LAST_API
        Logger     % left empty.  outer layers may populate this (e.g. Api)
    end

    properties (GetAccess=public, SetAccess=public, Description='api')
    % if declared here, children class cannot have a specific setter
    % Connected logical = false;
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
        
        function report(L,varargin)
            % verbose reporting (to be replaced by a proper call to
            %  AstroPack logger), like N.LogFile.write(msg)
            % Input: a character array, followed by optional arguments
            % All input arguments are formatted as sprintf(varargin{:});
            %  hence when there is more than one, the first argument
            %  has to be a format specifier, consistent with the types of
            %  the following arguments.
            global DefaultLogger
            if L.Verbose
                if isempty(DefaultLogger)
                    DefaultLogger = obs.api.ApiLogger('FilePath', 'no-location');
                end
                msg=sprintf(varargin{:});
                 % concatenate to handle \n in msg (note: fails if msg
                 %  contains %; it could be duplicated to %%)
                msg = [sprintf('{%s} ',class(L)),char(msg)];
                if isprop(L, 'Logger') && ~isempty(L.Logger)
                    ChosenLogger = L.Logger;
                else
                    ChosenLogger = DefaultLogger;
                end
                ChosenLogger.msgLog(LogLevel.Info, msg);
                    
            end
        end
        
        function reportDebug(L,varargin)
            % verbose reporting of debug messages, for .Verbose=2
            % (to be replaced by a proper call to
            %  AstroPack logger), like N.LogFile.write(msg)
            % Input: a character array, followed by optional arguments
            % All input arguments are formatted as sprintf(varargin{:});
            %  hence when there is more than one, the first argument
            %  has to be a format specifier, consistent with the types of
            %  the following arguments.
            global DefaultLogger
            if L.Verbose>1
                if isempty(DefaultLogger)
                    DefaultLogger = obs.api.ApiLogger('FilePath', 'no-location');
                end
                msg=sprintf(varargin{:});
                msg = [sprintf('{%s|%s} ',datestr(now,'HH:MM:SS.FFF'),...
                         class(L)),char(msg)]; % concatenate to handle \n in msg
                if isprop(L, 'Logger') && ~isempty(Obj.Logger)
                    ChosenLogger = L.Logger;
                else
                    ChosenLogger = DefaultLogger;
                end
                ChosenLogger.msgLog(LogLevel.Debug, msg);
            end
        end

        function reportException(L,ex,varargin)
            % report on stdout and set LastError, with the same argument
            % Input: a character array, followed by optional arguments
            % All input arguments are formatted as sprintf(varargin{:});
            %  hence when there is more than one, the first argument
            %  has to be a format specifier, consistent with the types of
            %  the following arguments.
            global DefaultLogger
            if isempty(DefaultLogger)
                DefaultLogger = obs.api.ApiLogger('FilePath', 'no-location');
            end
            msg=sprintf(varargin{:});
            L.LastError=msg;
            if isprop(L, 'Logger')
                if isempty(L.Logger)
                    Obj.Logger = DefaultLogger;
                else
                    L.Logger
                end
            end
            if isprop(L, 'Logger')
                if ~isempty(Obj.Logger)
                    ChosenLogger = Obj.Logger;
                else
                    ChosenLogger = DefaultLogger;
                end
            end
            ChosenLogger.msgLogEx(LogLevel.Error, ex, msg);
            rethrow(ex);
        end

    end
        
end


