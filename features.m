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
for i = 1:size(right,2)
    for j=1:size(right,3)       
        % Log Power alpha-band
        ralpha(i,j) = log(bandpower(right(:,i,j), fs, [f_alphalow f_alphahigh]));
        lalpha(i,j) = log(bandpower(left(:,i,j), fs, [f_alphalow f_alphahigh]));
    
        % Log Power beta-band
        rbeta(i,j) = log(bandpower(right(:,i,j), fs, [f_betalow f_betahigh]));
        lbeta(i,j) = log(bandpower(left(:,i,j), fs, [f_betalow f_betahigh]));
    
        % First difference
        T = length(right(:,i,j));
        Yr = 0; Yl = 0;
        for t = 1 : T - 1
            tempr = right(:,i,j); 
            templ = left(:,i,j);
            Yr = Yr + abs(tempr(t+1) - tempr(t));
            Yl = Yl + abs(templ(t+1) - templ(t));
        end
        rFD(i,j) = (1 / (T - 1)) * Yr;
        lFD(i,j) = (1 / (T - 1)) * Yl;
        clear Yr Yl tempr templ
    
        % Hjorth Activity
        rHA(i,j) = log(std(right(:,i,j)) ^ 2);
        lHA(i,j) = log(std(left(:,i,j)) ^ 2);
    
        % Hjorth complexity
        tempr = right(:,i,j); templ = left(:,i,j);
        rx0  = tempr(:); lx0  = templ(:);
        rx1  = diff([0; rx0]); lx1  = diff([0; lx0]);
        rx2  = diff([0; rx1]); lx2  = diff([0; lx1]);
        % Standard deviation of first & second derivative 
        rsd0 = std(rx0); lsd0 = std(lx0);
        rsd1 = std(rx1); lsd1 = std(lx1);
        rsd2 = std(rx2); lsd2 = std(lx2); 
        % Complexity
        rHjorthC(i,j)  = (rsd2 / rsd1) / (rsd1 / rsd0);
        lHjorthC(i,j)  = (lsd2 / lsd1) / (lsd1 / lsd0);
        % Hjorth mobility
        rHjorthM(i,j)  = rsd1 / rsd0;
        lHjorthM(i,j)  = lsd1 / lsd0;
    
        % Kurtosis
        rkur(i,j) = kurtosis(right(:,i,j));
        lkur(i,j) = kurtosis(left(:,i,j));
    
        % Log entropy
        rlogEn(i,j) = sum(log(tempr .^ 2));
        llogEn(i,j) = sum(log(templ .^ 2));
    
        % Log Root Sum Of Sequential Variation
        rY = zeros(1, T-1); lY = zeros(1, T-1);
        for t = 2:T
            rY(t-1) = (tempr(t) - tempr(t-1)) ^ 2;
            lY(t-1) = (templ(t) - templ(t-1)) ^ 2;
        end
        rLRSSV(i,j) = log10(sqrt(sum(rY)));
        lLRSSV(i,j) = log10(sqrt(sum(lY)));
        
        % Maximum
        rmax(i,j) = max(right(:,i,j));
        lmax(i,j) = max(left(:,i,j));
    
        % Mean curve length
        rY = 0; lY = 0;
        for m = 2:T
          rY = rY + abs(tempr(m) - tempr(m-1));
          lY = lY + abs(templ(m) - templ(m-1));
        end
        rMCL(i,j) = (1 / T) * rY;
        lMCL(i,j) = (1 / T) * lY;
    
        % Mean energy
        rME(i,j) = log(mean(tempr.^ 2));
        lME(i,j) = log(mean(templ.^ 2));
    
        % Mean Teager Energy
        rY = 0; lY = 0;
        for m = 3:T
          rY = rY + ((tempr(m-1) ^ 2) - tempr(m) * tempr(m-2));
          lY = lY + ((templ(m-1) ^ 2) - templ(m) * templ(m-2));
        end
        rTeager(i,j) = (1 / T) * rY;
        lTeager(i,j) = (1 / T) * lY;
    
        % Minimum
        rmin(i,j) = min(right(:,i,j));
        lmin(i,j) = min(left(:,i,j));
    
        % Normalized first and second difference
        rY1 = 0; lY1 = 0;
        for t = 1 : T - 1
          rY1 = rY1 + abs(tempr(t+1) - tempr(t));
          lY1 = lY1 + abs(templ(t+1) - templ(t));
        end
        rFD1  = (1 / (T - 1)) * rY1; lFD1  = (1 / (T - 1)) * lY1; 
        rNFD1(i,j) = rFD1 / std(tempr); 
        lNFD1(i,j) = lFD1 / std(templ);
        clear rSD
    
        % Normalized second difference
        rY2 = 0; lY2 = 0;
        for t = 1 : T - 2
          rY2 = rY2 + abs(tempr(t+2) - tempr(t));
          lY2 = lY2 + abs(templ(t+2) - templ(t));
        end
        rSD  = (1 / (T - 2)) * rY2; lSD  = (1 / (T - 2)) * lY2;
        rNSD(i,j) = rSD / std(tempr);
        lNSD(i,j) = lSD / std(templ);
        clear lSD
    
        % Ration power band alpha-beta
        ralphabeta(i,j) = ralpha(i,j)/rbeta(i,j);
        lalphabeta(i,j) = lalpha(i,j)/lbeta(i,j);
    
        % Second difference
        rY = 0; lY = 0;
        for t = 1 : T - 2
          rY = rY + abs(tempr(t+2) - tempr(t));
          lY = lY + abs(templ(t+2) - templ(t));
        end
        r2ndDiff(i,j) = (1 / (T - 2)) * rY;
        l2ndDiff(i,j) = (1 / (T - 2)) * lY;
    
        % Shannon entropy
        rP    = (tempr .^ 2) ./ sum(tempr .^ 2);
        lP    = (templ .^ 2) ./ sum(templ .^ 2);
        % Entropy 
        rEn   = rP .* log2(rP); lEn   = lP .* log2(lP);
        rShEn(i,j) = -sum(rEn);
        lShEn(i,j) = -sum(lEn);
    
        % Skewness
        rskew(i,j) = skewness(right(:,i,j));
        lskew(i,j) = skewness(left(:,i,j));
    
        % Tsallis Entropy
        rC = (tempr.^2) ./ sum(tempr.^ 2);
        lC = (templ.^2) ./ sum(templ.^ 2);
        % Entropy 
        rEn = rC.^2; lEn = lC.^2;
        rTsEn(i,j) = (1 / (2 - 1)) * (1 - sum(rEn(:))); 
        lTsEn(i,j) = (1 / (2 - 1)) * (1 - sum(lEn(:))); 
    end
end

fright = [ralpha; rbeta; rFD; rHA; rHjorthC; rHjorthM; rkur; rlogEn; rLRSSV; rmax; ...
     rMCL; rME; rTeager; rmin; rNFD1; rNSD; ralphabeta; r2ndDiff; rShEn; rskew; rTsEn];
fleft = [lalpha; lbeta; lFD; lHA; lHjorthC; lHjorthM; lkur; llogEn; lLRSSV; lmax; ...
     lMCL; lME; lTeager; lmin; lNFD1; lNSD; lalphabeta; l2ndDiff; lShEn; lskew; lTsEn];