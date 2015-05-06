classdef ReachDiscTC < elltool.control.test.mlunit.SintTC
 
    methods(Access = public)
        function self = ReachDiscTC(varargin)
            self = self@elltool.control.test.mlunit.SintTC(varargin{:});
           
            
        end

        function controlObj = getControlBuilder(self)
            controlObj=elltool.control.DiscreteControlBuilder(self.reachObj);
        end
    
    end
end