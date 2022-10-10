function [y_filt] = carfilter(yfilt)
% Common averaging filter

mu = mean(yfilt,2);        
    for i=1:size(yfilt,2)      % 2 indicates the columns of matrix
        xi = yfilt(:,i);       % EEG of a single channel
        y_filt(:,i) = xi-mu;  
    end
end