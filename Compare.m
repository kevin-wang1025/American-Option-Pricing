% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
%手動輸入參數
tic;
S = 100;
K = 100;
r = 0.05;
b = 0.03;
sigma = 0.3;
T = 1;
dr = 0.02;

%BAW模型之下美式選擇權的價格
[d1, european_price] = bs_model(S, K, T, r, b, sigma);
[q2, S_star] = Newton(1e-10, 10000);
d1_star = (log(S_star/K)+(b+1/2*sigma^2)*T) / (sigma*sqrt(T));

american_price = 0;
if S<S_star
    premium = (S_star/q2)*(1-exp((b-r)*T)*normcdf(d1_star))*(S/S_star)^q2;
    fprintf('美式溢價: %d\n',premium);
    american_price = european_price + premium;
else
    american_price = S - K;
end

baw_time = toc;

%Binomial model, LSMC, BAW之下美式選擇權價格之比較
[binomial_time, binomial] = BinomialModel(S, K, r, sigma, T, 1000, dr);
[lsmc_time, lsmc] = LSM_AmericanOption(S, K, r, 1, sigma, 252, 1000, dr);
baw = american_price;
fprintf("********************評價結果********************\n");
fprintf("Binomial之下美式選擇權價格: %d 計算時間: %d\n", binomial, binomial_time);
fprintf("LSMC之下美式選擇權價格: %d 計算時間: %d\n", lsmc, lsmc_time);
fprintf("BAW之下美式選擇權價格: %d 計算時間: %d\n", baw, baw_time);
    