function stock_data = read_yahoo_finance_csv(filename)

    arguments
        filename = "C:\Users\wynga\OneDrive\Desktop\PhD_Research\Options Trading\Stock Data\MSFT.csv";
    end
    
    csv_table = readtable(filename);

    % Initializing Struct
    stock_data(size(csv_table)) = struct();

    for index = 1:size(csv_table,1)
        stock_data(index).Date = csv_table.Date(index);
        stock_data(index).Open = csv_table.Open(index);
        stock_data(index).High = csv_table.High(index);
        stock_data(index).Low = csv_table.Low(index);
        stock_data(index).Close = csv_table.Close(index);
        stock_data(index).AdjClose = csv_table.AdjClose(index);
        stock_data(index).Volume = csv_table.Volume(index);
    end
end