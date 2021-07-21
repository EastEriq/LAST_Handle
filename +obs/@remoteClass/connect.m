function connect(R)
% connect the remote class (apparently necessary more for syntax, for 
%  uebermethods which connect any child object like unitCS.object; it seems
%  that the messenger itself can autoconnect on first call, maybe it is a
%  property of udp objects)
   R.Messenger.connect;
end