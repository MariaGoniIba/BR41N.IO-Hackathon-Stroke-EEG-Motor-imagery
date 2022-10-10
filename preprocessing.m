function [right, left] = preprocessing(y, trig, fs)

% Bandpass Filtering to get alpha and beta band information​
fl = 8;     % beginning of alpha
fh = 30;    % end of beta   ​
order = 4;
wn = [fl fh]/(fs/2);
type = 'bandpass';
[b,a] = butter(order,wn,type);
yfilt = filtfilt(b,a,y); % Filtered EEG signal

[y_filt] = carfilter(yfilt);

% Extract trials
empty_slot=[];
rightdata=repmat(empty_slot,length(trig),1);
leftdata=repmat(empty_slot,length(trig),1);
righttrialadd=repmat(empty_slot,40,1);
lefttrialadd=repmat(empty_slot,40,1);
righttrial=repmat(empty_slot,100,1);
lefttrial=repmat(empty_slot,100,1);

c1=0;
c2=0;
time=8;
triallength=fs*time;

for i=1:length(trig)
    if trig(i)== 0;
        continue
    elseif trig(i)== -1;
        c1=c1+1;
        rightdata(c1) = i;
        i= i+ (8*fs-1);
    else trig(i) == 1;
        c2=c2+1;
        leftdata(c2) = i;
        i= i+ (8*fs-1);
    end
end

nutrials = length(leftdata)/triallength; %Number of trials per class

for j=0:nutrials-1
    righttrialadd(j+1) = rightdata(j*triallength+1); %Index of the starting point of trial/ trial marker
    lefttrialadd(j+1)  = leftdata(j*triallength+1);

    righttrial(j+1).trial = y_filt(righttrialadd(j+1):righttrialadd(j+1)+(triallength-1),:); % structure of trials
    lefttrial(j+1).trial = y_filt(lefttrialadd(j+1):lefttrialadd(j+1)+(triallength-1),:);
end

% remove the first 2 seconds
righttrial = righttrial.trial;
lefttrial = lefttrial.trial;
right = []; left= [];
for i = 1:size(righttrial,2)
    temp = righttrial(:,i);
    temp = temp((fs*2+1):end);
    right(:,i) = temp;
    clear temp
    temp = lefttrial(:,i);
    temp = temp((fs*2+1):end);
    left(:,i) = temp;
    clear temp
end




