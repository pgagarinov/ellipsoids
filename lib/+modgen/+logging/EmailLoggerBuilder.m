classdef EmailLoggerBuilder
    methods (Access=private)
        function self=EmailLoggerBuilder()
        end
    end
    methods (Static)
        function emailLogger=fromConfRepoMgr(confRepoMgr,appName,...
                inpSubjSuffName,mainLogFileName,fTempDirGetter,varargin)
            %
            import modgen.common.throwerror;
            [~,~,addAttachNameList]=modgen.common.parseparext(varargin,...
                {'emailAttachmentNameList';...
                {};...
                'iscellofstring(x)'},0);
            [urlCodeStr,urlStr,branchName,revisionStr]=getRepoParams();
            %
            tmpDirName=fTempDirGetter(appName);
            %zip log file name
            zipLogFileName=[tmpDirName,filesep,'mainlog.zip'];
            %
            dstConfFileName=[tmpDirName,filesep,'cur_conf','.xml'];
            confRepoMgr.copyConfFile(dstConfFileName,'destIsFile',true);
            %
            
            [~,pidVal,~]=modgen.system.getpidhost();
            subjectSuffix=[',pid:',num2str(pidVal),',conf:',...
                confRepoMgr.getCurConfName(),inpSubjSuffName,...
                ',',urlCodeStr,':',urlStr];
            addArgList={};
            if confRepoMgr.isParam('emailNotification.smtpUserName')
                addArgList=[addArgList,{'smtpUserName',...
                    confRepoMgr.getParam('emailNotification.smtpUserName')}];
                if confRepoMgr.isParam('emailNotification.smtpPassword')
                    addArgList=[addArgList,{'smtpPassword',...
                        confRepoMgr.getParam('emailNotification.smtpPassword')}];
                end
            elseif confRepoMgr.isParam('emailNotification.smtpPassword')
                throwerror('wrongInput',['smtpPassword can only be ',...
                    'specified when smtpUser name is specified']);
            end
            
            emailLogger=modgen.logging.EmailLogger(...
                'emailDistributionList',...
                confRepoMgr.getParam('emailNotification.distributionList'),...
                'emailAttachmentNameList',...
                [{mainLogFileName,dstConfFileName},addAttachNameList],...
                'emailAttachmentZippedNameList',...
                [{zipLogFileName},cell(1,numel(addAttachNameList)+1)],...
                'smtpServer',confRepoMgr.getParam('emailNotification.smtpServer'),...
                'subjectSuffix',subjectSuffix,...
                'loggerName',...
                [appName,':',branchName,':',revisionStr],addArgList{:},...
                'dryRun',~confRepoMgr.getParam('emailNotification.isEnabled'));
        end
    end
end
function [urlCodeStr,urlStr,branchName,revisionStr]=getRepoParams()
curClassName=modgen.common.getcallername;
curDirStr=fileparts(which(curClassName));
urlCodeStr='';
try
    isSvn=modgen.subversion.issvn(curDirStr);
    if isSvn,
        isGit=false;
        urlCodeStr='svnURL';
        urlStr=modgen.subversion.svngeturl(curDirStr);
    else
        isGit=modgen.git.isgit(curDirStr);
        if isGit,
            urlCodeStr='gitURL';
            urlStr=modgen.git.gitgeturl(curDirStr);
        else
            throwerror('wrongObjState',...
                'Files with code should be under either SVN or Git');
        end
    end
catch
    isSvn=false;
    isGit=false;
    urlCodeStr='unknownURL';
    urlStr='unknown';
end
if isSvn,
    revisionStr=modgen.subversion.getrevision('ignoreErrors',true);
    branchName='unknown';
elseif isGit,
    revisionStr=modgen.git.gitgethash(curDirStr);
    branchName=modgen.git.gitgetbranch(curDirStr);
else
    revisionStr='unversioned';
end
end
