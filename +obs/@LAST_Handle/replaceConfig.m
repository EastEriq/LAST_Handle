function replaceConfig(L,FileName,Keys,NewValues)
% Read in a yml configuration file as text, replace the value of the given
%  key with the new value provided, and write back the text buffer to the
%  same file. Very basic funcionality, implemented loading the whole file
%  in memory and performing string substitutions; it may not work for 
%  complex datatypes
%
% Present use case, only to substitute numeric values, and only in existing
%   files. To be considered, also write anew nonexisting files and nonexisting
%   name-key pairs.
%
% Input: FileName the yml config file to work on (without path)
%        Keys, Values: cells of parameter names and their replacement
%                      values

if ~exist('Keys','var')
    Keys={};
    NewValues={};
end

if ~(isa(Keys,'char') || isa(Keys,'cell'))
    io.msgLog(LogLevel.Error,'''Keys'' should be a character or a cell array')
    return
end
if ~(isa(NewValues,'char') || isa(NewValues,'cell'))
    io.msgLog(LogLevel.Error,'''NewValues'' should be a character or a cell array')
    return
end
if (isa(Keys,'cell') && isa(NewValues,'cell') && numel(Keys)~=numel(NewValues)) ||...
   (isa(Keys,'char') && isa(NewValues,'cell') && numel(NewValues)~=1) || ...
   (isa(Keys,'cell') && isa(NewValues,'char') && numel(Keys)~=1)
    io.msgLog(LogLevel.Error,'''Keys'' and ''NewValues'' should both contain a single element')
    return
end
if isa(Keys,'char')
    Keys={Keys};
end
if isa(NewValues,'char')
    NewValues={NewValues};
end

%fullpath=fullfile(L.configPath,FileName);
fullpath=FileName; % when else FileName used to be only the prefix/file?

% read in the file in a cell array T, containing each line
try
    fid=fopen(fullpath,'r');
    T=textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    T=T{1};
catch
    io.msgLog(LogLevel.Error,'reading file ''%s'' failed',FileName);
    T={};
end

% search each key in each of the lines of the file, and if found, replace
%  the corresponding value
for i=1:numel(Keys)
    for j=1:numel(T)
        % simple parsing: count on that the first ':' and '#' are the delimiters
        entry=regexprep(T{j},':.*','');
        if strcmp(Keys{i},strtrim(entry))
            remain=regexprep(T{j},'.*:','');
            if contains(remain,'#')
                comment=regexprep(remain,'.*#','');
            else
                comment='';
            end
            newvalue=sprintf(['%' num2str(length(remain)-length(comment)-3) 's '],...
                             NewValues{i});
            if ~isempty(comment)
                T{j}=[entry, ': ', newvalue, '#' comment];
            else
                T{j}=[entry, ': ', newvalue];
            end
        end
    end
end

% write back T into the file
fid=fopen(fullpath,'w');
for j=1:numel(T)
    fprintf(fid,'%s\n',T{j});
end
fclose(fid);

    
