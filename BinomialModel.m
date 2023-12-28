% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
function result = BinomialModel(s0, K, r, sigma, T, n)
    delta_t = T/(n-1);
    u = exp(sigma*sqrt(delta_t)); %上漲幅度
    d = exp(-sigma*sqrt(delta_t)); %下跌幅度
    p = (exp(r*delta_t)-d) / (u-d); %上漲機率
    q = 1 - p; %下跌機率
    fprintf('上漲機率:');
    disp(p);
    fprintf('下跌機率:'); 
    disp(q);
    
    %股價和選擇權價值的矩陣
    temp = [];
    stockPrice = {[s0]};
    optionValue = {};
    
    %股價矩陣
    for i=2:n
        stockPrice{i} = [];
    end
    for i=2:n
        for j=1:length(stockPrice{i-1})
            if j==1
                stockPrice{i} = horzcat(stockPrice{i}, stockPrice{i-1}(j)*u);
                stockPrice{i} = horzcat(stockPrice{i}, stockPrice{i-1}(j)*d);
            else 
                stockPrice{i} = horzcat(stockPrice{i}, stockPrice{i-1}(j)*d);
            end
        end
    end
    
    disp('股價動態:');
    disp(stockPrice);
    
    %選擇權價值矩陣
    for i=1:n
        optionValue{i} = [];
    end
    for i=1:n
        for j=1:i
            optionValue{i}(j) = max(0,stockPrice{i}(j)-K);
        end
    end
    disp('各節點選擇權價值;');
    disp(optionValue);
    
    %根據各節點選擇權價值的樹狀圖計算美式選擇權的payoff
    for i=n:-1:3
        for j=1:i-1
            if optionValue{i-1}(j)~=0
                if ((optionValue{i}(j)*p + optionValue{i}(j+1)*q) * exp(-r*T/(n-1))) >= optionValue{i-1}(j)
                    optionValue{i-1}(j) = (optionValue{i}(j)*p + optionValue{i}(j+1)*q) * exp(-r*T/(n-1));
                else
                    optionValue{i-1}(j) = optionValue{i-1}(j);
                end
            else
                optionValue{i-1}(j) = (optionValue{i}(j)*p + optionValue{i}(j+1)*q) * exp(-r*T/(n-1));
            end 
        end
    end
    
    disp('選擇權價值計算');
    disp(optionValue);
    
    %全部路徑折現至第0期平均
    result = (optionValue{2}(1)*p + optionValue{2}(2)*q) * exp(-r*T/(n-1));
    disp('評價結果');
    disp(result);
end

%BinomialModel(100, 100, 0.05, 0.3, 1, 1000)












