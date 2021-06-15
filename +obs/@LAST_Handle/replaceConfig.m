function replaceConfig(L,FileName,Keys,NewValues)
% Read in a yml configuration file as text, replace the value of the given
%  key with the new value provided, and write back the text buffer to the
%  same file. Very basic funcionality, implemented with string
%  substitutions, which may not work for complex datatypes

% Present use case, only to substitute numeric values