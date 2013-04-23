classdef EllipsoidMinkpmPlotTestCase < mlunitext.test_case
    properties (Access=private)
        testDataRootDir
        
    end
    %
    methods
        function self = EllipsoidMinkpmPlotTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        function self = tear_down(self,varargin)
            close all;
        end
        function self = testSimpleOptions(self)
            import elltool.plot.test.testMinkFillAndShade
            import elltool.plot.test.testMinkColor
            import elltool.plot.test.testMinkProperties
            testFirEll = ellipsoid(2*eye(2));
            testSecEll = ellipsoid([1, 0].', [9 2;2 4]);
            testThirdEll = ellipsoid([1 0; 0 2]);
            testForthEll = ellipsoid([0, -1, 3].', 1.5*eye(3));
            testFifthEll = ellipsoid([5,5,5]', [6 2 1; 2 4 3; 1 3 5]);
            testSixthEll = ellipsoid([1 0 0; 0 2 0; 0 0 1]);
            self = testMinkFillAndShade(self,@minkpm,testFirEll,[testSecEll,testThirdEll]);
            self = testMinkFillAndShade(self,@minkpm,testForthEll,[testFifthEll testSixthEll]);
            self = testMinkColor(self,@minkpm,testFirEll,[testSecEll,testThirdEll],2);
            self = testMinkColor(self,@minkpm,testForthEll,[testFifthEll testSixthEll],1); 
            self = testMinkProperties(self,@minkpm,testFirEll,[testSecEll,testThirdEll]);
            self = testMinkProperties(self,@minkpm,testForthEll,[testFifthEll testSixthEll]); 
            minkpm(testFirEll,testSecEll,testThirdEll,'showAll',true);
            minkpm(testForthEll,testFifthEll,testSixthEll,'showAll',true);
        end
        function self = test2d(self)
            testFirEll = ellipsoid([1, 0].', [9 2;2 4]);
            testSecEll = ellipsoid(eye(2));
            testThirdEll = ellipsoid([2 1;1 2]);
            testForthEll=ellipsoid(diag([0.8 0.1]));
            testFifthEll=ellipsoid(diag([1 2]));
            check(testFirEll,testSecEll,testThirdEll);
            check(testFifthEll,testSecEll,testForthEll);
            
            function check(testFirEll,testSecEll,testThirdEll)
                absTol = 10^(-3);
                [~,boundPoints] = minkpm(testFirEll,testSecEll,testThirdEll);
                [lGridMat] = gras.geom.circlepart(200);
                [supp1Arr,~] = rho(testFirEll,lGridMat.');
                [supp2Arr,~] = rho(testSecEll,lGridMat.');
                [supp3Arr,~] = rho(testThirdEll, lGridMat.');
                rhoDiffVec = gras.geom.sup.supgeomdiff2d(supp1Arr+supp2Arr,supp3Arr,lGridMat.');
                sup = max(lGridMat*boundPoints(:,1:end-1),[],2);
                 abs(sup'-rhoDiffVec)
                mlunit.assert_equals(abs(sup'-rhoDiffVec) < absTol,ones(1,size(sup,1)));      
           
            end
        end
    end
end