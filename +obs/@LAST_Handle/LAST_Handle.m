classdef LAST_Handle < handle
     
    properties (Hidden)
        Config % name of the associated configuration file (searched in the configurations directory)
        CommSelf
        CommExt
    end
    
end