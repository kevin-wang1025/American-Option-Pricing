df = readtable("C:\Users\10830\Downloads\756F11CD-68E2-4A0A-90F1-F95F20D57854.csv");

%資料清洗
columnsToRemove = {'Var2','Var6','Var7','Var8','Var9','Var10','Var12','Var13','Var14','Var15',...
    'Var16','Var17','Var19','Var20'};
df = removevars(df, columnsToRemove);
newColumnNames = {'Date', 'Maturity', 'Strike', 'Type', 'Price', 'tradeTime'};
df.Properties.VariableNames = newColumnNames;
disp(df.Properties.VariableNames);

%把一般交易時段的買權資訊挑出來
filter1 = df.Type=="買權";
filter2 = df.tradeTime=="一般";
df = df((filter1 & filter2), :);

%改變maturity的表達方式
len = height(df);
for i=1:len
    if strcmp(df{i, 'Maturity'},'202401W1')
        df.Maturity{i} = num2str(days(datetime('2024-01-07')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202401W2')
        df.Maturity{i} = num2str(days(datetime('2024-01-14')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202401')
        df.Maturity{i} = num2str(days(datetime('2024-01-31')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202402')
        df.Maturity{i} = num2str(days(datetime('2024-02-28')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202403')
        df.Maturity{i} = num2str(days(datetime('2024-03-31')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202406')
        df.Maturity{i} = num2str(days(datetime('2024-06-30')-datetime('2023-12-28')) / 365);
    end
    if strcmp(df{i, 'Maturity'},'202409')
        df.Maturity{i} = num2str(days(datetime('2024-09-30')-datetime('2023-12-28')) / 365);
    end
end
MaturityString = df.Maturity;
Maturity = str2double(MaturityString);
df.Maturity = Maturity;
%disp(df);     

%計算隱含波動度
vol = [];
for i=1:len
    C = df.Price(i);
    S = 17910.37;
    K = df.Strike(i);
    r = 0.0385;
    T = df.Maturity(i);
    sigma = IV(C, S, K, r, T);
    vol = horzcat(vol, sigma);
end

for i=1:length(vol)
    df.Vol(i) = vol(i);
end

%二維線性插值


    
    
    
    
    
    
    
    
    
    

