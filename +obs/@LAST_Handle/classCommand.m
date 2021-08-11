function Result=classCommand(Obj,Command)
% Attempt to have an unified way of accessing properties and methods of
%  classes which may be either local (=within this matlab session) or
%  remote (i.e defined in a session connected via a couple of Messengers)
%
% Input  : - Either a remoteClass object, or some local object.
%          - A string containing a command to execute.
%          - Where to execute the command: 'base' | 'caller'.
%            Default is 'caller'.
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
% but usefulness of such contraptions is questionable 

% TODO: instead of Where, for which I don't see any more an use case,
%       consider an argument WaitReply. If false, and nargout=0, use
%       Messenger.send instead of .query [or suppress Result altogether]

if isempty(Obj)
    Result = [];
else
    if isa(Obj,'obs.remoteClass')
        QueryStr = [Obj.RemoteName '.' Command];  % old
        % switch always CallbackRespond to true for the (blocking) query
        respond=Obj.Messenger.CallbackRespond;
        Obj.Messenger.CallbackRespond=false;
        %
        Result = Obj.Messenger.query(QueryStr);
        % restore original CallbackRespond state
        Obj.Messenger.CallbackRespond=respond;
    else
        % how to understand if there is going to be a reply without calling the
        %  command twice?
        C=Obj; % this way we know that we have a temporary object called 'C', for sure
        if nargout>0
            Result = eval(['C.' Command]);
        else
            eval(['C.' Command]);
        end
    end
end