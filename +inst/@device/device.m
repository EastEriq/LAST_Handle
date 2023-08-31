classdef device < obs.LAST_Handle
    % class with common augmentations relevant to hardware devices

    properties (Hidden, GetAccess = public, SetAccess = private)
        Ready=struct('flag',true,'reason',''); % generic Ready property, each inheriter will have its getter logic
        WhenExpectedReady double =[]; % time at which twe anticipate that the resource may be ready (serial date number)
    end
    
end
