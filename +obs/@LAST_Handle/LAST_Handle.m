classdef LAST_Handle < handle
     
    properties (Hidden)
        Config % name of the associated configuration file (searched in the configurations directory)
        ConfigStruct   % The configuration structure loaded from file
    end
    
end