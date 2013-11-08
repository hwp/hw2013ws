% Excercise 2.2 for Optimal Control of ODEs
% Author : Weipeng He
% All rights (c) 2013 resvered

TRES = 5e-3 %resolution of t
opt = odeset ("RelTol", 1e-4, "AbsTol", 1e-4, "InitialStep", 1e-3, "MaxStep", TRES);


% a)
gu = @(t1) (@(t) (t > t1) * 2 -1);
gf = @(t1) (@(t, x) [-x(1) * x(2) * gu(t1)(t); x(1) * x(2) + (x(1) + x(2)) * gu(t1)(t) - x(1) - x(2) - gu(t1)(t)]);

I = @(t1) sum(ode45(gf(t1), [0 1], [1 1], opt).y(end,:) .^ 2);

tt = (.1:0.1:.9)';
[m n] = size(tt);
II = zeros(m, n);
for i = 1:m
  II(i) = I(tt(i));
end

[tt II]

% b)
dI = @(t1) (I(t1 + TRES) - I(t1)) / TRES;

% c)
lt = 0.1; % Assume dI(lt) > 0
ut = 0.9; % Assume dI(ut) < 0

while ((ut - lt) > TRES)
  m = (ut + lt) / 2;
  if (dI(m) > 0)
    lt = m;
  else
    ut = m;
  end
end

fprintf("Root of I'(t1) is %.3f\n", m);
fprintf("max I(t1) = %.4f\n", I(m));

[tt xx] = ode45(gf(m), [0 1], [1 1], opt);
uu = arrayfun(gu(m), tt);

figure;
hold on;
plot(tt, xx(:, 1), "b;x_1;");
plot(tt, xx(:, 2), "g;x_2;");
plot(tt, uu, "r;u;");
title("Optimal Trajectory x(t;t_1^*)");
xlabel("t");

