clc;
clear;
close all;

%% PARAMETERS

fs = 2000;              % sampling frequency
f = 50;                 % fundamental frequency
t = 0:1/fs:1;

V_nominal = 230;
I_peak= 8;
phi = pi/6;             % Phase angle (30 degrees lag)

window = 200;           % buffer size

sag_th = 0.9*V_nominal;
swell_th = 1.1*V_nominal;

%% SIGNAL GENERATION

voltage = V_nominal*sin(2*pi*f*t);
current = I_peak * sin(2*pi*f*t - phi);

% disturbances
voltage(t>0.25 & t<0.35) = 0.6*voltage(t>0.25 & t<0.35);
voltage(t>0.55 & t<0.65) = 1.4*voltage(t>0.55 & t<0.65);
voltage = voltage + 20*sin(2*pi*3*f*t) + 10*sin(2*pi*5*f*t);

voltage(1400:1405) = voltage(1400:1405) + 350;

%% BUFFER + STORAGE

buffer = zeros(1,window);
Vrms = zeros(size(voltage));

event_type = strings(length(voltage),1);

%% EVENT TRACKING

sag_active = false;
swell_active = false;

sag_start = 0;
swell_start = 0;

sag_events = [];
swell_events = [];

%% RMS CALCULATION (Sliding Window)
window_size = fs/f;     % One cycle window

Vrms = zeros(size(t));
Irms = zeros(size(t));

for k = window_size:length(t)
    Vrms(k) = sqrt(mean(voltage(k-window_size+1:k).^2));
    Irms(k) = sqrt(mean(current(k-window_size+1:k).^2));
end

%% POWER CALCULATION
instantaneous_power = voltage .* current;

P_real = movmean(instantaneous_power, window_size);
S_apparent = Vrms .* Irms;
power_factor = P_real ./ S_apparent;


%% REAL TIME STREAMING LOOP

for k = 1:length(voltage)

    % shift buffer
    buffer = [buffer(2:end) voltage(k)];

    if k >= window

        % RMS calculation
        Vrms(k) = sqrt(mean(buffer.^2));

        %% SAG DETECTION

        if Vrms(k) < sag_th

            event_type(k) = "SAG";

            if ~sag_active
                sag_active = true;
                sag_start = k;
            end

        else
            if sag_active
                sag_end = k;
                sag_events = [sag_events; sag_start sag_end];
                sag_active = false;
            end
        end

        %% SWELL DETECTION

        if Vrms(k) > swell_th

            event_type(k) = "SWELL";

            if ~swell_active
                swell_active = true;
                swell_start = k;
            end

        else
            if swell_active
                swell_end = k;
                swell_events = [swell_events; swell_start swell_end];
                swell_active = false;
            end
        end

    end

end

%% TRANSIENT DETECTION

dv = diff(voltage);

transient_events = find(abs(dv) > 200);

%% FFT + THD

N = length(voltage);

Y = fft(voltage);

P2 = abs(Y/N);
P1 = P2(1:N/2+1);

freq = fs*(0:(N/2))/N;

[~,fund_idx] = min(abs(freq-f));
fund_mag = P1(fund_idx);

harmonics = [3 5 7];
harm_power = 0;

for h = harmonics

    idx = min(find(freq >= h*f));
    harm_power = harm_power + P1(idx)^2;

end

THD = sqrt(harm_power)/fund_mag;

%% REPORT

disp("------ POWER QUALITY REPORT ------")

disp("Sag events detected:")
disp(size(sag_events,1))

disp("Swell events detected:")
disp(size(swell_events,1))

disp("Transient events detected:")
disp(length(transient_events))

disp("Estimated THD:")
disp(THD)

fprintf('Final Power Factor: %.2f\n', mean(power_factor(end-window_size:end)));

%% PLOTS

figure

subplot(3,1,1)
plot(t,voltage)
title("Voltage Signal")

subplot(3,1,2)
plot(t,Vrms)
title("Sliding RMS")

subplot(3,1,3)
plot(freq,P1)
title("FFT Spectrum")