% S0=100, K=100, r=0.05, T=1, sigma=0.3, step=252, n=1000
function [time, result] = LSM_AmericanOption(s0, K, r, T, sigma, step, n, dr)
    tic;
    
    %Step1:模擬出N條股價的路徑
    paths = zeros(n,step); 
    
    for i=1:n
        paths(i,1) = s0; 
        for j=2:step
            s = paths(i,j-1) * exp((r-dr-sigma^2/2)*(T/step) + sigma*(randn()*sqrt(T/step)));                   
            paths(i,j) = s;
        end
        %fprintf('模擬次數:%d\n',i);
    end
    
    figure;
    plot(transpose(paths));
    title('Monte Carlo Simulation');
    xlabel('Steps');
    ylabel('Price');
    
    %Step2:求出各路徑到期時(T)選擇權的價格
    finalValue = zeros(1,n);
    for i=1:n
        finalValue(1,i) = max(0,paths(i, step)-K);
    end
    
    for i=1:n
        paths(i, step) = finalValue(1, i);
    end
    
    %disp(paths);
    
    %Step3:找出在前一期(T-1)屬於價內選擇權的路徑點，令其股價等於S
    %Step4:將上述點的下一期(T期)選擇權價格以無風險利率折現回T-1期，並令其值為y
    %Step5:將y和S跑迴歸
    %Step6:利用已知迴歸式，求出T-1期，每一個價內股價S下，y的期望價值
    %Step7:比較履約價值和期望值，如果前者大則提早履約
    
    for s=step:-1:2 %第幾步
        
        S = [];
        %把那些價內股價的索引加到array中
        for i=1:n
            if paths(i, s-1) >= K
                S = horzcat(S, i);
            end
        end

        % Y對S跑迴歸(y = a0 + a1S + a2s^2)
        x = [];
        y = [];

        for j = S
            x = horzcat(x, paths(j, s-1)); %價內的那些股價
            y = horzcat(y, paths(j, s)*exp(-r*T/step)); %後一期折現回來的股價
        end
        
        %disp('要跑迴歸的資料');
        %disp(x);
        %disp(y);
        p = polyfit(x, y, 2);
        a0 = p(3);
        a1 = p(2);
        a2 = p(1);

        %如果今天j在S裡，代表其對應的股價為價內，我們需要比較預期價格和履約價格，反之我們直接以折現值當作該節點價值
        for j=1:n
            if ismember(j, S) 
                if (paths(j, s-1)-K) >= (a0+a1*paths(j, s-1)+a2*paths(j, s-1)^2) %直接履約比繼續持有價值高
                    paths(j, s-1) = paths(j, s-1)-K;
                    paths(j, s) = 0;
                else
                    paths(j, s-1) = paths(j, s)*exp(-r*T/step);
                end 
            else
                paths(j, s-1) = paths(j, s)*exp(-r*T/step);
            end 
        end
        %disp(paths);
        %disp('=======================================================================================');
    end
   
    %計算折現到第0期
    sum = 0;
    for i=1:n
        for j=1:step
            if paths(i, j)~=0
                sum = sum + paths(i, j)*exp(-r*T/step*(j-1));
                break;
            end
        end
    end
    result = sum / n;
    disp(result); 
    
    time = toc;
end
    
%LSM_AmericanOption(100, 100, 0.05, 1, 0.3, 252, 1000, 0.02)

    
    
    
    
    
    
    
    
    
    
    
