function [right, left] = preprocessing(data, trig, fs)

% Bandpass filter keeping alpha and beta information​
fl = 8;
fh = 30;
[b,a] = butter(4,[fl fh]/(fs/2),'bandpass');
% Filter and Common averaging reference
yfilt = filter(b,a,data-mean(data,2)); 

% Extract trials
right=[]; left=[];
for i = 2:size(yfilt)
    if trig(i)==-1 && trig(i-1)==0 % right
        right = [right; yfilt(i+3.5*fs:i+5*fs-1)];
    elseif trig(i)==1 && trig(i-1)==0 % left
        left = [left; yfilt(i+3.5*fs:i+5*fs-1)];
    end
end
