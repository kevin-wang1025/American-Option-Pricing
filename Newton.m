% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
%用牛頓法求解臨界價格
function [q2, result] = Newton(tol, maxIter)

    %手動調整參數
    r = 0.05;
    b = 0.03;
    T = 1;
    sigma = 0.3;
    K = 100;
    
    %定義目標函數 
    M = 2*r/sigma^2;
    N = 2*b/sigma^2;
    X = 1-exp(-r*T);
    q2 = (-N+1+sqrt((N-1)^2+4*M/X)) / 2;
    
    %f = @(S) S - K - bs_model(S, K, T, r, b, sigma) - (1-exp((b-r)*T)*...
    %    normcdf((log(S/K)+(b+1/2*sigma^2)*T) / (sigma*sqrt(T))))*S/q2;
    
    %最佳起始值
    q2i = (-N+1+sqrt((N-1)^2+4*M)) / 2;
    Si = K/(1-1/q2i);
    h2 = -1*(b*T+2*sigma*sqrt(T))*(K/(Si-K));
    S = K + (Si-K)*(1-exp(h2)); %起始值
    fprintf('起始值: %d\n', S);
    [d1, c] = bs_model(S, 100, 1, 0.05, 0.03, 0.3);
    lhs = S - K;
    rhs = c + (1-exp((b-r)*T)*normcdf(d1))*S/q2;
    bi = exp((b-r)*T)*normcdf(d1)*(1-1/q2) + (1-exp((b-r)*T)*normpdf(d1)/(sigma*sqrt(T)))/q2;
    
    %迭代求解過程
    iteration = 0;
    while abs(lhs-rhs)/K>tol && iteration<maxIter
        fprintf('第%d次迭代 ',iteration+1);
        S = (K+rhs-bi*S)/(1-bi);
        [d1, c] = bs_model(S, 100, 1, 0.05, 0.03, 0.3);
        lhs = S - K;
        rhs = c + (1-exp((b-r)*T)*normcdf(d1))*S/q2;
        bi = exp((b-r)*T)*normcdf(d1)*(1-1/q2) + (1-exp((b-r)*T)*normpdf(d1)/(sigma*sqrt(T)))/q2;
        
        fprintf('Error: %d\n',abs(lhs-rhs)/K);
        iteration = iteration + 1;
    end 
    
    fprintf('臨界股價: %d',S);
    result = S;
end

%Newton(1e-10, 10000)
