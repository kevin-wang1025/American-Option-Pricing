% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
function sigma = IV(C, S, K, r, T, initialGuess)
    
    %Black-Scholes公式
    f = @(sigma) C - S*normcdf((log(S/K)+(r+1/2*sigma^2)*T) / (sigma*sqrt(T))) + K*exp(-r*T)*...
        normcdf((log(S/K)+(r-1/2*sigma^2)*T) / (sigma*sqrt(T)));
    
    
    %用牛頓法求解隱含波動度
    sigma = fzero(f, initialGuess);
end

