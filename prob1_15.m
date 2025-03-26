clear all; close all;

fs = 16000;     % sampling frequency
T = 0.1;        % duration of 1 bit signal
fc = 500;       % carrier

name = 'Michal';

bits = [];         % Here we'll keep the 0s and 1s

%%% First, for every letter of the name, we will take its ASCII value
%%% and convert it to binary. Then, we will put it into the 'bits' array.
%%% One should note, that 'dec2bin' returns a string value, so we must 
%%% change it to a number

for i = 1:length(name)
    ascii_value = int8(name(i));    % changing it to ASCII value
    bit = dec2bin(ascii_value, 8);  % converting to binary (string!)
    bits = [bits, bit - '0'];       % adding to array as number
end

%%% y = linspace(x1,x2) returns a row vector of evenly spaced 
%%% points between x1 and x2. y = linspace(x1,x2,n) generates n points.
%%% The spacing between the points is (x2-x1)/(n-1)

t_bit = linspace(0, T, fs*T);
s = zeros(1, length(bits) * length(t_bit));  % the signal

%%% for every bit we transmit positive for 0 and negative for 1

for i = 1:length(bits)
    start_1 = (i-1) * length(t_bit) + 1;
    end_1 = i * length(t_bit);
    
    if bits(i) == 0
        % positive for 0
        s(start_1:end_1) = sin(2*pi*fc*t_bit);
    else
        % negative for 1
        s(start_1:end_1) = -sin(2*pi*fc*t_bit);
    end
end

dt = 1/fs;
Nx = length(s);
t = dt * (0:Nx-1);

figure;
plot(t, s, 'o-');
grid; title('Signal x(t)'); xlabel('time [s]'); ylabel('Amplitude');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fx_values = [8000, 16000, 24000, 32000, 48000];
for fx = fx_values
    fprintf('Playing signal with fx = %d Hz\n', fx);
    sound(s, fx);
    pause(length(s)/fx + 1);
end

audiowrite('transmitted_signal.wav', s, 8000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

number_of_bits = 8 .* length(name);
decoded_bits = zeros(1, number_of_bits);

for i = 1:number_of_bits
    start_ = (i-1)*fs*T + 1;
    end_ = i*fs*T;
    interval = s(start_:end_);

    if sum(interval .* sin(2*pi*fc*t_bit))>0
        decoded_bits(i) = 0;
    else
        decoded_bits(i) = 1;
    end
end    

number_of_letters = number_of_bits/8;
d_name = '';


for i = 1:number_of_letters
    bits_num = decoded_bits((i-1)*8+1 : i*8);
    bit_str = num2str(bits_num);
    bit_str(isspace(bit_str)) = []; % remove spaces
    ascii_decoded = bin2dec(bit_str);
    d_name = [d_name, char(ascii_decoded)];
end

fprintf('Decoded name: %s\n', d_name);
