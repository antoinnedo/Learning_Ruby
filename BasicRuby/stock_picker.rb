#idea:only update min price if the profit is better

def stock_picker(stocks)
  return [0, 0] if stocks.empty? || stocks.size == 1

  min_stock = stocks[0]
  min_day = 0
  max_profit = 0
  best_day = -Float::INFINITY

  stocks.each.with_index do |stock, sell_day|
    if stock < min_stock
      min_stock = stock
      min_day = sell_day
    end

    current_profit = stock - min_stock

    if current_profit > max_profit
      max_profit = current_profit
      best_day = [min_day, sell_day]
    end
  end

  best_day
end

p stock_picker([17,3,6,9,15,8,6,1,10])
