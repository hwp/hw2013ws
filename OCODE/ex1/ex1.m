y2 = @(t, x) 2 + x(1) * (1 - t.^2) + x(2) * (1 - t.^4);

dy2 = @(t, x) -2 * x(1) * t - 4 * x(2) * t.^3;

g = @(t, x) y2(t,x) .* sqrt(1 + dy2(t, x).^2);

w = [1/2 ones(1,63) 1/2]' / 32;
f = @(x) g(0:1/64:1,x) * w;

%x = fminsearch(@f, [0 0]);
x1 = -10:1:10;
x2 = x1;
ff = zeros(length(x1));
for i = 1:length(x1)
  for j = 1:length(x2)
    ff(i,j) = f([x1(i) x2(j)]);
  endfor
endfor

contourf(x1, x2, ff);
colorbar;

