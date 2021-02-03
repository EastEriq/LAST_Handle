function result=classCommand(obj,command)
% Attempt to have an unified way of accessing properties and methods of
%  classes which may be either local (=within this matlab session) or
%  remote (i.e defined in a session connected via a couple of Messengers)
%
% Examples:
%
%  classCommand(localMount,'goTo(12,34)')
%     translates in: localMount.goTo(12,34) executed in the present matlab
%     session
%
%  classCommand(remoteMount,'goTo(12,34)')
%     translates into:
%     remoteMount.MessengerQuery('remoteMount.Name.goTo(12,34)')
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
% This instead would still work:
% 
%   classCommand(remoteMount,['Alt=' remoteMount '.Alt+10'])
%  
% but usefulness of such contraptions is questionable 

%  result=classCommand(localMount,'goTo(12,34)')
if isa(obj,'obs.remoteClass')
    result=obj.Messenger.query([obj.Name '.' command]);
else
    % how to understand if there is going to be a reply without calling the
    %  command twice?
    C=obj; % this way we know that we have a temporary object called 'C', for sure
    if nargout>0
        result=eval(['C.' command]);
    else
        eval(['C.' command]);
    end
end