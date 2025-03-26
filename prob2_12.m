clear all; close all;

fs = 8000;               % Sampling frequency

% Create audio
recording = audiorecorder(fs, 16, 1);  
disp('Please click any button and say "a", "e", "i", "o", "u", etc....');
pause;
record(recording);
pause(2);
stop(recording);
disp('Recording complete.');
x = getaudiodata(recording);

% Normalization
x = x / max(abs(x));

% Plot the recorded phoneme
figure;
subplot(3,1,1);
plot(x); % o-
xlabel('Sample index');
ylabel('Amplitude');
title('Recorded Phoneme Signal');
grid on;

% built-in xcorr
Rxx = xcorr(x, x);
N = length(x);
lags = -(N-1):(N-1);

subplot(3,1,2);
plot(lags, Rxx);
xlabel('Lag (samples)');
ylabel('Autocorrelation');
title('Autocorrelation using xcorr()');
grid on;

% manual
Rxx_manual = zeros(2*N-1, 1);
for k = -(N-1):(N-1)
    if k < 0
        % For negative lag: 1-k to N for x(n) and 1 to N+k for x(n+k)
        Rxx_manual(k+N) = sum(x(1-k:end) .* x(1:end+k));
    else
        % For nonnegative lag: 1 to N-k for x(n) and 1+k to N for x(n+k)
        Rxx_manual(k+N) = sum(x(1:end-k) .* x(1+k:end));
    end
end

subplot(3,1,3);
plot(lags, Rxx_manual, 'r');
xlabel('Lag (samples)');
ylabel('Autocorrelation');
title('Manually Computed Autocorrelation');
grid on; 


sound(x, fs); 
