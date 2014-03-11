classdef TouchTestCase < mlunitext.test_case
    properties
    end
    
    methods
        function self = TouchTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        function testControl(~)
            import modgen.io.TmpDataManager;
            import elltool.demo.test.control.*
            testFileName = modgen.common.getcallername(1);
%             [pathstrVec, ~, ~] = fileparts(which(testFileName));
%             pathstrVec = [modgen.path.rmlastnpathparts(pathstrVec, 1),filesep,'+control'];
%             TmpDataManager.setRootDir(pathstrVec);
%             fileNameSArray = dir(pathstrVec);
%             fileNameSArray = fileNameSArray(3:end);
%             for nameIterator = 1 : size(fileNameSArray,1)
%                 testName = modgen.string.splitpart...
%                     (fileNameSArray(nameIterator).name, '.', 'first');
%                 fTest = str2func(testName);
%                 if (strcmp(testName,'tt'))
%                     fTest();
%                 end
%             end
            anim1();
            anim2();
            anim3();
            anim4();
            anim5();
            anim6();
            backdist();
            bigd();
            bigd1();
            bigd();
            circ();
            circ1();
            coll();
            ctback();
            ctreach();
            ctreach3D();
            ctreach4();
%             degdist();
            mech();
            reachdist();
            reachdist5();
            tt();
            close all;
            mlunitext.assert(true);
        end
        
    end
end