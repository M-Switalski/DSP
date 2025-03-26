clear all; close all;

% Sampling frequency
fs = 8000;

recording = audiorecorder(fs, 16, 1);  % 16-bit, mono recording
disp('Please click any button and speak...');
pause;
record(recording);
pause(5);
stop(recording);
disp('Recording complete.');
x = getaudiodata(recording);

% Normalization
x = x / max(abs(x));

zer = zeros(1000,1);
x_new = 0.5*[x; zer; zer] + 0.45*[zer; x; zer] + 0.40*[zer; zer; x];
soundsc(x_new,fs);


delays = [0, 400, 800];

coeffs = [1/2, 1/4, 1/8];

L = length(x);

% The output length is the original length plus the maximum delay.
N = L + max(delays);

x_sum = zeros(N,1);  % output signal

for k = 1:length(delays)
    d = delays(k);
    coeff = coeffs(k);
    
    % temporary vector of zeros with the proper length
    temp = zeros(N,1);
    
    % Place the original signal x into the temp vector at the correct delay
    temp((d+1):(d+L)) = x;
    
    temp = coeff * temp;
    
    % Sum the delayed copy into the output signal
    x_sum = x_sum + temp;
end

disp('Playing the final signals...');
disp('First the recorded one...');
sound(x, fs);
pause(6);
disp('Now the delayed one...')
sound(x_sum, fs);
