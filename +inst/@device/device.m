classdef device < obs.LAST_Handle
    % class with common augmentations relevant to hardware devices

    properties (Hidden, GetAccess = public, SetAccess = private)
        WhenExpectedReady double =[]; % time at which twe anticipate that the resource may be ready (serial date number)
    end
    
    methods
        % creator
        function D=device()
            % call the parent creator to define the property listeners
            D@obs.LAST_Handle;
        end
    end
end
