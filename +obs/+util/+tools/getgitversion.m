function versionstring=getgitversion(fullpath)
% generic for all LAST_Handle objects, but not a getter
    p=fileparts(fullpath);
    % git describe is compact, but works only if there is a tag in the
    %  ancestor
    
    % long signature, using git log with format
    %  produces something like
    %    HEAD -> gledmagicwater, origin/gledmagicwater 3c54732 2024-06-09
    % piping into | cat avoids 'WARNING: terminal is not fully functional
    %     -  (press RETURN)
    % [~,r]=system(['cd ' p ';git log -n 1 --format="%D %h %as" | cat']);
    
    % more compact, by pieces
    [~,r]=system(['cd ' p ...
        ';echo `git branch --show-current` `git tag` `git log -n 1 --format="%h %as"`']);
    if ~contains(r,'fatal: not a git repository')
        versionstring=strrep(r,newline,'');
    else
        versionstring='not on a git repo';
    end