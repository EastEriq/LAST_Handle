function disconnect(R)
% disconnect the remote class (apparently necessary more for syntax, for 
%  uebermethods which disconnect any child object like unitCS.object)
   R.Messenger.disconnect;
end