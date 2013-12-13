w = 2;
v0 = 2;

dydt = @(t, y) y(5) * [-w*y(3)/sqrt(y(3)^2+y(4)^2); v0*(1-y(1)^2)-w*y(4)/sqrt(y(3)^2+y(4)^2); 2*y(4)*v0*y(1); 0; 0];
bc = @(ya, yb) [ya(1)+1; yb(1)-1; ya(2); yb(2); ya(3)^2+yb(3)^2-1/w^2];

solinit = bvpinit(linspace(0,1), [.5;0.2;1;1;1.5]);

sol = bvp4c(dydt, bc, solinit);
y = sol.y;
time = y(5,1) * sol.x;

figure;
plot(y(1,:), y(2,:));
title(sprintf('time = %f', y(5,1)));

