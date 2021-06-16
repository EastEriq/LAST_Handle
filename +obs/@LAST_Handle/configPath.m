function Path=configPath(L)
% Returns the path to the directory where all configuration files reside

    functionpath=fileparts(mfilename('fullpath'));

    % For now the configuration files are all in a flat subdir of LAST_config,
    %  but it may be sensible to move them to one or more global common
    %  directories
    % We could make use for instance of class(L) for different subdirs
    Path=fullfile(functionpath,'..','..','..','LAST_config','config');
    % using coreutils' realpath makes a shorter string, but is not portable.
    [~,Path]=system(['realpath ' Path]);
    Path=Path(1:end-1);
    % Matlab seems not to have a native equivalent, and I don't want to add
    %  an external dependency like
    %  https://www.mathworks.com/matlabcentral/fileexchange/28249-getfullpath