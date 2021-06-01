function Result=search_key_in_all_config(Obj,ConfigBaseName,Keys)
% Search some keyword in all configuration files

    PWD = pwd;
    ConfigDir = configfile.pathname;
    cd(ConfigDir)
    Files = dir(sprintf('%s*',ConfigBaseName));
    cd(PWD);

    Nkey = numel(Keys);

    N = numel(Files);
    for I=1:1:N
        Struct = loadConfiguration(Obj,Files(I).name,false);
        % search Keys
        for Ikey=1:1:Nkey
            if isfield(Struct,Keys{Ikey})
                Result(I).(Keys{Ikey}) = Struct.(Keys{Ikey});
            else
                Result(I).(Keys{Ikey})  = NaN;
            end
        end
    end

end
