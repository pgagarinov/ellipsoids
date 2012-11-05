function T = trace(E)
%
% TRACE - returns the trace of the ellipsoid.
%
%
% Description:
% ------------
%
%    T = TRACE(E)  Computes the trace of ellipsoids in ellipsoidal array E.
%
%
% Output:
% -------
%
%    T - array of trace values, same size as E.
%
%
% See also:
% ---------
%
%    ELLIPSOID/ELLIPSOID.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%

  import elltool.conf.Properties;

  [m, n] = size(E);
  T      = [];

  for i = 1:m
    t = [];
    for j = 1:n
      t = [t trace(double(E(i, j)))];
    end
    T = [T; t];
  end

  return;
