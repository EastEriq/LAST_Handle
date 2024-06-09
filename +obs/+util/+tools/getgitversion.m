function versionstring=getgitversion(fullpath)
% generic for all LAST_Handle objects, but not a getter
    p=fileparts(fullpath);
    % piping into | cat avoids 'WARNING: terminal is not fully functional
    %     -  (press RETURN)
    [~,r]=system(['cd ' p ';git log -n 1 --format="%D %h %as" | cat']);
    versionstring=strrep(r,newline,'');
