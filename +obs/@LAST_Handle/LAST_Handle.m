classdef LAST_Handle < handle
     
    properties (Hidden)
        Config         % name of the associated configuration file (searched in the configurations directory)
        ConfigStruct   % The configuration structure loaded from file
        Verbose=1;     % textual verbosity. 0=suppress, 1=report info, 2=blabber
    end
    
    properties (Hidden, GetAccess = public, SetAccess = private)
        LastError='';  % The last error message
    end
    
    methods
    end
    
end

