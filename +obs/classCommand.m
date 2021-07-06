function Result=classCommand(Obj,Command,IndName)
% Attempt to have an unified way of accessing properties and methods of
%  classes which may be either local (=within this matlab session) or
%  remote (i.e defined in a session connected via a couple of Messengers)
%
% Input  : - Either a remoreObject, or some device object.
%            This object must have a Name property.
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


% if nargin<3
%     Where = 'caller';
% end
% switch lower(Where)
%     case 'caller'
%         EvalInListener = false;
%         

if nargin<3
    IndName = '';
end

if isnumeric(IndName)
    IndName = sprintf('%s(%d)',Obj.Name,IndName);
end

if isempty(Obj)
    Result = NaN;
else
    if isa(Obj,'obs.remoteClass')
        
        QueryStr = [Obj.Name '.' Command];  % old
        Result=Obj.Messenger.query(QueryStr);
    else
        % how to understand if there is going to be a reply without calling the
        %  command twice?
        C=Obj; % this way we know that we have a temporary object called 'C', for sure
        if nargout>0
            Result=eval(['C.' Command]);
            %Result=eval([Obj.Name '.' Command]);
            %Result = eval([C.Name '.' Command]);
        else
            Result = eval(['C.' Command]);
        end
    end
end