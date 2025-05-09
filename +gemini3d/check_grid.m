%% CHECK_GRID basic check that grid is reasonable

function ok = check_grid(xg)
arguments
  xg (1,1) struct
end

tol_inc = 1e-6;  % MZ - patched to function with dipole grids
tol_inc_big = 1e6;
tol_big = 1e9;

ok = true;

%% minimum size checks
for k = ["x1", "x2", "x3"]
  lx = length(xg.(k));
  if lx < 5
    warning("Each dimension must have at least 5 points, but l" + k + "=" + int2str(lx))
  end
end

%% check for monotonic increasing and reasonable dimension size
for k = ["x1", "x1i", "x2", "x2i", "x3", "x3i"]
  p = squeeze(xg.(k));
  ok = ok && is_monotonic_increasing(p, tol_inc, tol_inc_big, k);
  ok = ok && not_too_big(p, tol_big, k);
end

%% geo lat/lon

if ~all(xg.glat <= 90 & xg.glat >= -90)
  warning('geo latitude outside expected range')
  ok = false;
end

if ~all(xg.glon >= 0 & xg.glon <= 360)
  warning('geo longitude outside expected range')
  ok = false;
end

end % function


function ok = is_monotonic_increasing(A, tol, big, name)

narginchk(4,4)

dA = diff(A);

ok = all(dA > tol);

if ~ok
  warning('check_grid:is_monotonic_increasing', '%s not sufficiently monotonic increasing', name)
end

ok_big = all(abs(dA) < big);
if ~ok_big
  warning('check_grid:is_monotonic_increasing', '%s has unreasonably large differences', name)
end

ok = ok && ok_big;

end % function


function ok = not_too_big(A, tol, name)

narginchk(3,3)

ok = all(abs(A) < tol);

if ~ok
  warning('check_grid:not_too_big', '%s is too large to be reasonable.', name)
end

end % function
