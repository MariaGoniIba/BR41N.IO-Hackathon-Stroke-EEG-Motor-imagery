function [right, left] = preprocessing(data, trig, fs)

% Bandpass filter keeping alpha and beta information​
fl = 8;
fh = 30;
[b,a] = butter(4,[fl fh]/(fs/2),'bandpass');
yfilt = filter(b,a,data); 

% Common average referencing
yfilt = yfilt-mean(yfilt,2);

% Extract trials
right=[]; left=[]; trialr = 0; triall=0;
for i = 2:size(trig,1)
    if trig(i)==-1 && trig(i-1)==0 % right
        trialr = trialr +1;
        right(trialr,:,:) = yfilt(i+3.5*fs:i+5*fs-1,:);
    elseif trig(i)==1 && trig(i-1)==0 % left
        triall = triall +1;
        left(triall,:,:) = yfilt(i+3.5*fs:i+5*fs-1,:);
    end
end
