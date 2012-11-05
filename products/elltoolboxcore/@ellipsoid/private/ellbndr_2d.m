function x = ellbndr_2d(E)
%
% ELLBNDR_2D - compute the boundary of 2D ellipsoid.
%

  import elltool.conf.Properties;

  N      = Properties.getNPlot2dPoints();
  phi    = linspace(0, 2*pi, N);
  l      = [cos(phi); sin(phi)];
  [r, x] = rho(E, l);
  x      = [x x(:, 1)];

  return;
