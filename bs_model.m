function [d1, c] = bs_model(S_star, K, T, r, b, sigma)
    d1 = (log(S_star/K)+(b+1/2*sigma^2)*T) / (sigma*sqrt(T));
    d2 = d1 - sigma*sqrt(T);
    c = S_star*exp((b-r)*T)*normcdf(d1) - K*exp(-r*T)*normcdf(d2); %Black Scholes formula
end

