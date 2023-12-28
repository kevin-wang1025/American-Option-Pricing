function Newton(initialGuess, tol, maxIter)

    %手動調整參數
    r = 0.05;
    b = 0.03;
    T = 1;
    sigma = 0.3;
    K = 100;
    
    %定義目標函數 
    M = 2*r/sigma^2;
    N = 2*b/sigma^2;
    q2 = (-N+1+sqrt((N-1)^2+4*M/K)) / 2;
    
    f = @(S) S - K - bs_model(S, 100, 1, 0.05, 0.03, 0.3) - (1-exp((b-r)*T)*...
        normcdf((log(S/K)+(b+1/2*sigma^2)*T) / (sigma*sqrt(T))))*S/q2;
    
    %迭代求解過程
    S = initialGuess;
    iteration = 0;
    
    disp(f(110));
end
