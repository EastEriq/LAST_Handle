function listAllProperties(X)
% lists the name and some attributes of all visible and hidden properties
%  of the object, without accessing their values

x=metaclass(X);

for i=1:numel(x.PropertyList)
    prop=x.PropertyList(i);
    if prop.Hidden
        hidden=' (Hidden)';
    else
        hidden='';
    end
    if strcmp(prop.SetAccess,'private') && strcmp(prop.GetAccess,'public')
        readwrite=' (readonly)';
    elseif strcmp(prop.SetAccess,'public') && strcmp(prop.GetAccess,'private')
        readwrite=' (writeonly)';
    else
        readwrite='';
    end
    h=help([class(X) '.' prop.Name]);
    helpline=h;
    % trim redundant repetition of the property name, if it is there
    redh=[prop.Name ' -  '];
    nh=strfind(helpline,redh);
    if ~isempty(nh)
        helpline=helpline(nh+numel(redh):end);
    end
    fprintf('%s\t:%s%s %s',prop.Name,hidden,readwrite,helpline)
end