function Obj=updatePropFromConfig(Obj,ListProp,ConfigStruct)
% Update the properties in the Object according to their
% value in ConfigStruct.
% Input  : - An object (e.g., obs.camera object).
%          - A cell array of properties to copy from the
%            ConfigStruct to the object.
%            E.g.,
%            {'CameraType','CameraName','CameraModel'}
%          - ConfigStruct: A structure containing the
%            Config file content. If not provided, then will
%            be taken from the Obj.ConfigStruct.
    if nargin<3
        ConfigStruct = Obj.ConfigStruct;
    end

    Nprop = numel(ListProp);
    for Iprop=1:1:Nprop
        %ListProp{Iprop}
        if isfield(ConfigStruct,ListProp{Iprop})
            Obj.(ListProp{Iprop}) = ConfigStruct.(ListProp{Iprop});
        else
            Obj.LogFile.write(sprintf('Error: Property %s was not found in ConfigStruct',ListProp{Iprop}));
        end
    end
end
