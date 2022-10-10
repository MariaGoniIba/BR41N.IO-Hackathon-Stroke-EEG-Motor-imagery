function [fright, fleft] = features(right, left, fs)

% Parameters
ordAR = 4; % order autoregressive model
% alpha band
f_alphalow  = 8;     
f_alphahigh = 12;    
% beta band
f_betalow  = 12;     
f_betahigh = 30;      

rTeager = []; lTeager = []; ralpha = []; lalpha = []; rvar = []; lvar = []; ralphabeta = []; lalphabeta = [];
for i=1:size(right,2)    
    % Autoregressive model 
    Y  = arburg(right(:,i),ordAR); 
    rAR(:,i) = Y(2 : ordAR + 1); 
    clear Y
    Y  = arburg(left(:,i),ordAR); 
    lAR(:,i) = Y(2 : ordAR + 1); 
    clear Y

    % Log Power alpha-band
    ralpha(i) = log(bandpower(right(:,i), fs, [f_alphalow f_alphahigh]));
    lalpha(i) = log(bandpower(left(:,i), fs, [f_alphalow f_alphahigh]));

    % Log Power beta-band
    rbeta(i) = log(bandpower(right(:,i), fs, [f_betalow f_betahigh]));
    lbeta(i) = log(bandpower(left(:,i), fs, [f_betalow f_betahigh]));

    % First difference
    T = length(right(:,i));
    Yr = 0; Yl = 0;
    for t = 1 : T - 1
        tempr = right(:,i); 
        templ = left(:,i);
        Yr = Yr + abs(tempr(t+1) - tempr(t));
        Yl = Yl + abs(templ(t+1) - templ(t));
    end
    rFD(i) = (1 / (T - 1)) * Yr;
    lFD(i) = (1 / (T - 1)) * Yl;
    clear Yr Yl tempr templ

    % Hjorth Activity
    rHA(i) = log(std(right(:,i)) ^ 2);
    lHA(i) = log(std(left(:,i)) ^ 2);

    % Hjorth complexity
    tempr = right(:,i); templ = left(:,i);
    rx0  = tempr(:); lx0  = templ(:);
    rx1  = diff([0; rx0]); lx1  = diff([0; lx0]);
    rx2  = diff([0; rx1]); lx2  = diff([0; lx1]);
    % Standard deviation of first & second derivative 
    rsd0 = std(rx0); lsd0 = std(lx0);
    rsd1 = std(rx1); lsd1 = std(lx1);
    rsd2 = std(rx2); lsd2 = std(lx2); 
    % Complexity
    rHjorthC(i)  = (rsd2 / rsd1) / (rsd1 / rsd0);
    lHjorthC(i)  = (lsd2 / lsd1) / (lsd1 / lsd0);
    % Hjorth mobility
    rHjorthM(i)  = rsd1 / rsd0;
    lHjorthM(i)  = lsd1 / lsd0;

    % Kurtosis
    rkur(i) = kurtosis(right(:,i));
    lkur(i) = kurtosis(left(:,i));

    % Log entropy
    rlogEn(i) = sum(log(tempr .^ 2));
    llogEn(i) = sum(log(templ .^ 2));

    % Log Root Sum Of Sequential Variation
    rY = zeros(1, T-1); lY = zeros(1, T-1);
    for t = 2:T
        rY(t-1) = (tempr(t) - tempr(t-1)) ^ 2;
        lY(t-1) = (templ(t) - templ(t-1)) ^ 2;
    end
    rLRSSV(i) = log10(sqrt(sum(rY)));
    lLRSSV(i) = log10(sqrt(sum(lY)));
    
    % Maximum
    rmax(i) = max(right(:,i));
    lmax(i) = max(left(:,i));

    % Mean curve length
    rY = 0; lY = 0;
    for m = 2:T
      rY = rY + abs(tempr(m) - tempr(m-1));
      lY = lY + abs(templ(m) - templ(m-1));
    end
    rMCL(i) = (1 / T) * rY;
    lMCL(i) = (1 / T) * lY;

    % Mean energy
    rME(i) = log(mean(tempr.^ 2));
    lME(i) = log(mean(templ.^ 2));

    % Mean Teager Energy
    rY = 0; lY = 0;
    for m = 3:T
      rY = rY + ((tempr(m-1) ^ 2) - tempr(m) * tempr(m-2));
      lY = lY + ((templ(m-1) ^ 2) - templ(m) * templ(m-2));
    end
    rTeager(i) = (1 / T) * rY;
    lTeager(i) = (1 / T) * lY;

    % Minimum
    rmin(i) = min(right(:,i));
    lmin(i) = min(left(:,i));

    % Normalized first and second difference
    rY1 = 0; lY1 = 0;
    for t = 1 : T - 1
      rY1 = rY1 + abs(tempr(t+1) - tempr(t));
      lY1 = lY1 + abs(templ(t+1) - templ(t));
    end
    rFD1  = (1 / (T - 1)) * rY1; lFD1  = (1 / (T - 1)) * lY1; 
    rNFD1(i) = rFD1 / std(tempr); 
    lNFD1(i) = lFD1 / std(templ);
    clear rSD

    % Normalized second difference
    rY2 = 0; lY2 = 0;
    for t = 1 : T - 2
      rY2 = rY2 + abs(tempr(t+2) - tempr(t));
      lY2 = lY2 + abs(templ(t+2) - templ(t));
    end
    rSD  = (1 / (T - 2)) * rY2; lSD  = (1 / (T - 2)) * lY2;
    rNSD(i) = rSD / std(tempr);
    lNSD(i) = lSD / std(templ);
    clear lSD

    % Ration power band alpha-beta
    ralphabeta(i) = ralpha(i)/rbeta(i);
    lalphabeta(i) = lalpha(i)/lbeta(i);

    % Second difference
    rY = 0; lY = 0;
    for t = 1 : T - 2
      rY = rY + abs(tempr(t+2) - tempr(t));
      lY = lY + abs(templ(t+2) - templ(t));
    end
    r2ndDiff(i) = (1 / (T - 2)) * rY;
    l2ndDiff(i) = (1 / (T - 2)) * lY;

    % Shannon entropy
    rP    = (tempr .^ 2) ./ sum(tempr .^ 2);
    lP    = (templ .^ 2) ./ sum(templ .^ 2);
    % Entropy 
    rEn   = rP .* log2(rP); lEn   = lP .* log2(lP);
    rShEn(i) = -sum(rEn);
    lShEn(i) = -sum(lEn);

    % Skewness
    rskew(i) = skewness(right(:,i));
    lskew(i) = skewness(left(:,i));

    % Tsallis Entropy
    rC = (tempr.^2) ./ sum(tempr.^ 2);
    lC = (templ.^2) ./ sum(templ.^ 2);
    % Entropy 
    rEn = rC.^2; lEn = lC.^2;
    rTsEn(i) = (1 / (2 - 1)) * (1 - sum(rEn(:))); 
    lTsEn(i) = (1 / (2 - 1)) * (1 - sum(lEn(:))); 
end

fright = [rAR; ralpha; rbeta; rFD; rHA; rHjorthC; rHjorthM; rkur; rlogEn; rLRSSV; rmax; ...
     rMCL; rME; rTeager; rmin; rNFD1; rNSD; ralphabeta; r2ndDiff; rShEn; rskew; rTsEn];
fleft = [lAR; lalpha; lbeta; lFD; lHA; lHjorthC; lHjorthM; lkur; llogEn; lLRSSV; lmax; ...
     lMCL; lME; lTeager; lmin; lNFD1; lNSD; lalphabeta; l2ndDiff; lShEn; lskew; lTsEn];

% fright = [ralpha; rbeta];
% fleft = [lalpha; lbeta];