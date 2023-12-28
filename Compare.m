% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
%手動輸入參數
S = 100;
K = 100;
r = 0.05;
b = 0.03;
sigma = 0.3;
T = 1;

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

%Binomial model, LSMC, BAW之下美式選擇權價格之比較
binomial = BinomialModel(100, 100, 0.05, 0.3, 1, 1000);
lsmc = LSM_AmericanOption(100, 100, 0.05, 1, 0.3, 252, 1000);
baw = american_price;
fprintf("********************評價結果********************\n");
fprintf("Binomial之下美式選擇權價格: %d\n", binomial);
fprintf("Binomial之下美式選擇權價格: %d\n", lsmc);
fprintf("BAW之下美式選擇權價格: %d\n", baw);
    