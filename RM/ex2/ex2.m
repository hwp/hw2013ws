% Exploratory Data Analysis

p = 0;

%read data, safe every column in a vector
[id sex wrh nwh wh fold pulse clap exer smoke height mi age] \
  = textread("survey", "%s %s %f %f %s %s %f %s %s %s %f %s %f");

%create numeric vector from binary string data 
sexm = strcmp("Male", sex);
sexf = strcmp("Female", sex);

whr = strcmp("Right", wh);
whl = strcmp("Left", wh);

foldr = strcmp("RonL", fold);
foldl = strcmp("LonR", fold);
foldn = strcmp("Neither", fold);

clapr = strcmp("Right", clap);
clapl = strcmp("Left", clap);
clapn = strcmp("Neither", clap);

exerf = strcmp("Freq", exer);
exers = strcmp("Some", exer);
exern = strcmp("None", exer);

smoker = strcmp("Regul", smoke);
smokeo = strcmp("Occas", smoke);
smoken = strcmp("Never", smoke);

mii = strcmp("Imperial", mi);
mim = strcmp("Metric", mi);

% Hand Size Difference
% Writing vs Non-writing
diff = wrh - nwh;
valid = isfinite(diff);
diff = diff(valid);

me = mean(diff);
sd = std(diff);
kt = kurtosis(diff);
fprintf("Writing vs Non-writing : mean = %f; std = %f; kurtosis = %f\n", me, sd, kt);

figure;
subplot(2, 1, 1);
hist(diff, -3:.5:3); 
title("Writing vs Non-writing");

% Right vs Left
diff = (wrh - nwh) .* (whr - whl);
diff = diff(valid & (whr | whl));

me = mean(diff);
sd = std(diff);
kt = kurtosis(diff);
fprintf("Right vs Left : mean = %f; std = %f; kurtosis = %f\n", me, sd, kt);

subplot(2, 1, 2);
hist(diff, -3:.5:3); 
title("Right vs Left");

if (p)
  print handdiff.png
end

% Pulses and Excercise
valid = isfinite(pulse);
pulsef = pulse(exerf & valid);
pulses = pulse(exers & valid);
pulsen = pulse(exern & valid);

figure;

me = mean(pulsef);
sd = std(pulsef);
fprintf("Frequently Pulse : mean = %f; std = %f\n", me, sd);

subplot(3, 1, 1);
hist(pulsef, 40:10:120);
title("Frequently");

me = mean(pulses);
sd = std(pulses);
fprintf("Some Pulse : mean = %f; std = %f\n", me, sd);

subplot(3, 1, 2);
hist(pulses, 40:10:120);
title("Some");

me = mean(pulsen);
sd = std(pulsen);
fprintf("None Pulse : mean = %f; std = %f\n", me, sd);

subplot(3, 1, 3);
hist(pulsen, 40:10:120);
title("None");
xlabel("Pulse");

if (p)
  print pulseexer.png
end

% Pulses and Gender
pulsem = pulse(sexm & valid);
pulsef = pulse(sexf & valid);

figure;

me = mean(pulsem);
sd = std(pulsem);
fprintf("Male Pulse: mean = %f; std = %f\n", me, sd);

subplot(2, 1, 1);
hist(pulsem, 40:10:120);
title("Male");

me = mean(pulsef);
sd = std(pulsef);
fprintf("Female Pulse: mean = %f; std = %f\n", me, sd);

subplot(2, 1, 2);
hist(pulsef, 40:10:120);
title("Female");
xlabel("Pulse");

if (p)
  print pulsegender.png
end

% Pulses and Height
valid = isfinite(pulse) & isfinite(height);
puf = pulse(valid);
hef = height(valid);

co = corr(puf, hef);
fprintf("Correlation between Pulse and Height : %f\n", co);

figure;
plot(hef, puf, "o");
title("Pulse and Height");
xlabel("Height");
ylabel("Pulse");

if (p)
  print pulseheight.png
end

% Pulses and Age 
valid = isfinite(pulse) & isfinite(age);
puf = pulse(valid);
agf = age(valid);

co = corr(puf, agf);
fprintf("Correlation between Pulse and Age : %f\n", co);

figure;
plot(agf, puf, "o");
title("Pulse and Age");
xlabel("Age");
ylabel("Pulse");

if (p)
  print pulseage.png
end

% All numerical data
hsize = (wrh + nwh) / 2;
valid = isfinite(hsize + pulse + height + age);
ndata = [hsize pulse height age](valid, :);

fprintf("Correlation Matrix (Hand Size, Pulse, Height, Age)\n");
display(corr(ndata));

figure;
plot(height, hsize, 'o');
xlabel("Height");
ylabel("Hand Size");
title("Hand Size and Height");

if (p)
  print handheight.png
end

