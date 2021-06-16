function loadConfig(L,ConfigFileName)
% Reads all configuration parameters from the given file, and assign the values
%  found to matching properties of L. Copy the entire configuration
%  structure, including parameters which have been ignored, to L.Config
%
% Input  :  A configuration file name to read. The file is searched
%           in the canonical configuration path given by L.configPath
%
% Example: M.loadConfig('obs.mount.1.create.yml');

    C=Configuration;
    % fields C.Path and C.External, whatever they are for, are not used
    %  here
    C.loadFile(fullfile(L.configPath,ConfigFileName),'Field',false);
    
    % scan all the parameters read from the file and assign
    configproperties=fieldnames(C.Data);
    x=metaclass(L);
    allproperties={x.PropertyList.Name};
    
    for i=1:numel(configproperties)
        if any(strcmp(allproperties,configproperties{i}))
            % assign the value to the corresponding property
            L.(configproperties{i})=C.Data.(configproperties{i});
        end
        % copy anything found in C.Data into L.Info. (we could as well
        %  decide to copy there only what is not an object property itself)
        % If a field already exists in L.Config overwrite its value,
        %  if not create a new field
        L.Config.(configproperties{i})=C.Data.(configproperties{i});
        % the rationale for overwriting is that I don't see a use case
        %  in which we may be interested in keeping the history of the
        %  changes of a config parameters through the lifetime of the
        %  object, notably the possibly different values at creation and at
        %  connection
    end
    
