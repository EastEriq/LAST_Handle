function Result=classCommand(Obj,varargin)
% Attempt to have an unified way of accessing properties and methods of
%  classes which may be either local (=within this matlab session) or
%  remote (i.e defined in a session connected via a couple of Messengers)
%
% Input  : - Either a remoteClass object, or some local object.
%          - A character array, containing the command to execute,
%             followed by optional arguments.
%           The input arguments beyonfd the class object are formatted
%             through sprintf(varargin{:}); hence when there is more 
%             than one, the first argument has to be a format specifier,
%             consistent with the types of the following arguments.
%
% Examples:
%
%  classCommand(localMount,'goTo(12,34)')
%     translates in: localMount.goTo(12,34) executed in the present matlab
%     session
%
%  classCommand(remoteMount,'goTo(12,34)')
%     translates into:
%     remoteMount.Messenger.query(['remoteMount.' RemoteName '.goTo(12,34)'])
%
% Other examples:  classCommand(localMount,'RA=12.34')
%                  result=classCommand(remoteMount,'RA')
%                  remoteMount.classCommand('RA=%f',-45.67)
%
% In any case, the command to be issued locally or remotely is always
%  built as obj.command. This limits the possible uses to very simple
%  constructs assigning or reading individual class properties, or calling
%  class methods with constant arguments and at most one return value.
%
% That is, don't expect anything like 
%
%    classCommand(remoteMount,'a=M.Alt; b=M.Az') to make any sense
%
% This instead could still work:
% 
%   classCommand(remoteMount,['Alt=' remoteMount.RemoteName '.Alt+10'])
%  
% but usefulness of such contraptions is questionable.
%
% To suppress output, end the command string with ';'.

% TODO: instead of Where, for which I don't see any more an use case,
%       consider an argument WaitReply. If false, and nargout=0, use
%       Messenger.send instead of .query [or suppress Result altogether]

if isempty(Obj)
    Result = [];
else
    try
        Command=sprintf(varargin{:});
    catch
        Obj.reportError('illegal arguments passed to classCommand')
        return
    end
    if isa(Obj,'obs.remoteClass')
        QueryStr = [Obj.RemoteName '.' Command];  % old
        try
            % flush eventual input leftovers. Normally there should be no
            %  unprocessed data in the udp input buffer, but there turns
            %  to be when the reader is interrupted, or there is
            %  miscommunication. This is an attempt to reediate a
            %  posteriori
            flushinput(Obj.Messenger.StreamResource);
            % switch always CallbackRespond to true for the (blocking) query
            respond=Obj.Messenger.CallbackRespond;
            Obj.Messenger.CallbackRespond=false;
            %
            Result = Obj.Messenger.query(QueryStr);
            % restore original CallbackRespond state
            Obj.Messenger.CallbackRespond=respond;
        catch
            Obj.reportError('invalid or uninitialized remote class %s',...
                            Obj.Id)
            Result=[];
        end
    else
        % how to understand if there is going to be a reply without calling the
        %  command twice?
        try
            C=Obj; 
            % this way we know that we have a temporary object called 'C', for sure
            if nargout>0
                Result = eval(['C.' Command]);
            else
                eval(['C.' Command]);
            end
        catch
            Obj.reportError('invalid class command "%s" to object %s',...
                             Command, Obj.Id)
        end
    end
end