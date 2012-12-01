function [ resQMat diagQVec ] = findDiffINFC(fMethod, ellObj1,ellObj2,...
    curDirVec,isInf1Vec,absTol)
% FINDDIFFINFC - find approximation for Minkowsky difference
% of ellipsoids (first ellipsoid is exactly infinite)
%
% Input:
%   regular:
%       fMethod: function_handle: [1,1] - specify external or internal
%           approximation
%       ellObj1: Ellipsoid: [1,1] - generalized ellipsoid
%       ellObj2: Ellipsoid: [1,1] - generalized ellipsoid
%       curDirVec: double: [nSize,1] - direction of calculation
%       isInf1Vec: logical: [nSize,1] - specify which directions are
%           infinite for the first ellipsoid
%       absTol: double: [1,1] - absolute tolerance
%
% Output:
%   resQMat: double: [nSize,nSize]/[0,0] - matrix of eigenvectors of
%       approximation ellipsoid. Empty when for external approximation the
%       specified direction is bad.
%   diagQMat: double: [nSize,nSize]/[0,0] - matrix of eigenvalues of
%       approximation ellipsoid. Empty when for external approximation the
%       specified direction is bad.
%
% $Author: Vitaly Baranov  <vetbar42@gmail.com> $    $Date: Nov-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2012 $
%
import elltool.core.Ellipsoid;
eigv1Mat=ellObj1.eigvMat;
eigv2Mat=ellObj2.eigvMat;
ell1DiagVec=diag(ellObj1.diagMat);
ell2DiagVec=diag(ellObj2.diagMat);
nDimSpace=length(ell1DiagVec);
allInfDirMat=eigv1Mat(:,isInf1Vec);
[ infBasMat,  finBasMat, infIndVec, finIndVec] =...
    Ellipsoid.findSpaceBas( allInfDirMat,absTol );
%Find projections on nonInf directions
isInf2Vec=ell2DiagVec==Inf;
ell1DiagVec(isInf1Vec)=0;
ell2DiagVec(isInf2Vec)=0;
curProjDirVec=finBasMat.'*curDirVec;
resProjQ1Mat=Ellipsoid.findMatProj(eigv1Mat,...
    diag(ell1DiagVec),finBasMat);
resProjQ2Mat=Ellipsoid.findMatProj(eigv2Mat,...
    diag(ell2DiagVec),finBasMat);
if all(abs(curProjDirVec)<absTol)
    resQMat=eye(nDimSpace);
    resQMat(:,infIndVec)=infBasMat;
    resQMat(:,finIndVec)=finBasMat;
    diagQVec=zeros(nDimSpace,1);
    diagQVec(infIndVec)=Inf;
else
    %Find result in finite projection
    finDimSpace=length(finIndVec);
    infDimSpace=nDimSpace-finDimSpace;
    finEllMat=Ellipsoid.findDiffFC(fMethod,resProjQ1Mat,resProjQ2Mat,...
        curProjDirVec,absTol);
    if isempty(finEllMat)
        resQMat=[];
        diagQVec=[];
    else
        [diagQVec, resQMat]=Ellipsoid.findConstruction(...
            finEllMat,finBasMat,infBasMat,finIndVec,...
            infIndVec,Inf*ones(1,infDimSpace));
    end
end
end
