function updateConfiguration(X,FileName,varargin)
% Replace a keyword name in a config file
% Input  : - FileName
%          - Keyword
%          - Value.
%          - Units. Default is ''.
%
% Example: X.ppdateConfiguration('try.txt','Long','31.0','');


configfile.replace_config(FileName,varargin{:});