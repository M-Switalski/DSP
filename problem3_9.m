clear all; close all;

fs = 8000;                           % Sampling frequency (sps)
recording = audiorecorder(fs, 16, 1);     % 16-bit, mono recording
disp('Click the button and speak a vowel (a, e, i, o, u) for about 2 seconds.');
pause;
record(recording);
pause(2);
stop(recording);
disp('Recording complete.');

x = getaudiodata(recording);

figure;
plot(x);
title('Recorded Vowel Sound');  
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

n1 = 6000; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ndct = 2^13;   % Number of samples for DCT calculation

% Extract the stationary fragment
x_fragment = x(n1:n1+Ndct-1);

% Plot the stationary fragment
figure;
plot(x_fragment);
title('Stationary Signal Fragment');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% DCT
c = dct(x_fragment, 'Type', 4);

% Plot the DCT coefficients
figure;
plot(c, '.-');
title('DCT (Type IV) Coefficients');
xlabel('Coefficient Index');
ylabel('Magnitude');
grid on;

% First Maximum
[maxVal, maxIdx] = max(c);
disp(['The first maximum in the DCT coefficients is ', num2str(maxVal), ' at index ', num2str(maxIdx)]);

% Generating a Cosine with Fundamental Frequency f0
T = 0.01;           % 80 / 8000         
f0 = 1 / T;

% Generate a cosine signal of the same length as the DCT fragment with frequency f0.
n = 0:Ndct-1;
cosine_signal = cos(2*pi*f0*n/fs);

% Plot the generated cosine signal
figure;
plot(cosine_signal, '.-');
title(['Cosine Signal with f0 = ', num2str(f0), ' Hz']);
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
