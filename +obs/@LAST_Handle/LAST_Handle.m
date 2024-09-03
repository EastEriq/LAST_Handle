classdef LAST_Handle < handle
    % The Mother of al LAST classes, which provides some common properties,
    %  like .Id, .LastError, .Verbose, and some general methods, like
    %  .loadConfig, .displayProperties
     
    properties (Hidden)
        Verbose=1; % textual verbosity. 0=suppress, 1=report info, 2=blabber
        Config     % struct of all fields read from the configuration, including those which are only informative
        PushPropertyChanges = false; % react to PostSet and PostGet events for Observable properties
    end
    
    properties (Hidden, GetAccess = public, SetAccess = protected)
        Id char; % a free text logical label, like '1_2_3' (for e.g. pier 1, mount 2, camera 3)
        PhysicalId char; % a physical identifier for the device (if applicable), like a serial number, or the connection port name
        LastError char;  % The last error message
        GitVersion char; % a string for storing git version information
        PVstore % an object to connect with the process Variable store (e.g. Redis)
    end
    
    methods
        % generic superclass creator - sets listeners for all
        %  observable properties
        function L=LAST_Handle()
% Not mature enough. Commented out
%             mc=metaclass(L);
%             for i=1:numel(mc.PropertyList)
%                 if mc.PropertyList(i).SetObservable
%                     addlistener(L, mc.PropertyList(i).Name,'PostSet',...
%                                 @L.pushPropertySet);
%                 end
%                 if mc.PropertyList(i).GetObservable
%                     addlistener(L, mc.PropertyList(i).Name,'PostGet',...
%                                 @L.pushPropertyGet);
%                 end
%             end
        end
    end
    
    methods
        % Setter to toggle push to Redis on or off
        %  (more to make it optional for certain objects, than to toggle it
        %  during the object lifetime)
        function set.PushPropertyChanges(L,flag)
            if flag
                try
                    L.PVstore=Redis('localhost', 6379, 'password', 'foobared');
                catch
                end
            else
                if ~isempty(L.PVstore)
                    delete(L.PVstore);
                    L.PVstore=[];
                end
            end
        end
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
            if L.Verbose
                msg=sprintf(varargin{:});
                 % concatenate to handle \n in msg (note: fails if msg
                 %  contains %; it could be duplicated to %%)
                %prefix=sprintf('{%s} ',class(L));
                prefix=sprintf('{%s|%s[%s]} ',datestr(now,'HH:MM:SS.FFF'),...
                                class(L),L.Id);
                fprintf([prefix,char(msg)])
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
            if L.Verbose>1
                msg=sprintf(varargin{:});
                fprintf([sprintf('{%s|%s} ',datestr(now,'HH:MM:SS.FFF'),...
                         class(L)),char(msg)]) % concatenate to handle \n in msg
            end
        end

        function reportError(L,varargin)
            % report on stdout and set LastError, with the same argument
            % Input: a character array, followed by optional arguments
            % All input arguments are formatted as sprintf(varargin{:});
            %  hence when there is more than one, the first argument
            %  has to be a format specifier, consistent with the types of
            %  the following arguments.
            msg=sprintf(varargin{:});
            L.LastError=msg;
            L.report([msg,'\n'])
        end
        
        % event listener callbacks for generic get and set properties:
        %  to be used to push data to a PV store
        % interesting observation: L.(Source.Name) can apparently
        %  be accessed within the callback function without
        %  triggering the callback an additional time. But this does not
        %  mean that the getter is not called an additional time.
        %  EventData.AffectedObject.(Source.Name), the same.
        %  Also the help doesn't show a way to retrieve the value which has
        %  just been set, without calling the getter again.
        % We could restrict these callbacks to properties which have an
        %  empty getter or setter. The assumption would be that
        %  they don't because they access a property in memory, and
        %  it is affordable to call them multiple times, whereas
        %  the presence of a getter or a setter is synonimous of a routine
        %  accessing a resource. This is not at all guaranteed to be true,
        %  though.
        % We cou also consider to use a special keyword for that in the field
        %  Source.Description, like it was done in webapiTransition
        % Also, beware of pushing big values. In particular,
        %  camera.LastImage!!!
        function pushPropertySet(L,Source,EventData)
            if L.PushPropertyChanges
                if isempty(Source.GetMethod)
                    fprintf('%s %s %s being set to\n',class(L),L.Id,Source.Name);
                    disp(L.(Source.Name))
                else
                   fprintf('%s %s %s being set\n',class(L),L.Id,Source.Name);
                   fprintf(' you should add something to the setter, to use the value\n');
                end
            end
        end
        
        function pushPropertyGet(L,Source,EventData)
            if L.PushPropertyChanges
                if isempty(Source.GetMethod)
                    fprintf('%s %s got %s\n',class(L),L.Id,Source.Name);
                    disp(L.(Source.Name))
                else
                   fprintf('%s %s %s retrieved\n',class(L),L.Id,Source.Name);
                   fprintf(' you should add something to the getter, to use the value\n');
                end
            end
        end

        % pushing to Redis
        function pushPVvalue(L,value)
            if ~isempty(L.PVstore)
                stack=dbstack();
                fun=stack(end).name;
                key=sprintf('%s:%s',fun,L.Id);
                L.PVstore.set(key,value);
            end
        end
    end
        
end

