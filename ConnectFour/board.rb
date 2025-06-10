class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(7) { Array.new(6) }
  end

  def display
    puts "\n  1    2    3    4    5    6    7"
    puts "+----+----+----+----+----+----+----+"

    6.times do |row|
      row_display = '|'
      7.times do |col|
        cell = @grid[col][5-row]
        row_display += " #{cell || '  '} |"
      end
      puts row_display
      puts "+----+----+----+----+----+----+----+"
    end
    puts
  end

  def drop_piece(column, symbol)
    (0..5).each do |row|
      if @grid[column][row].nil?
        @grid[column][row] = symbol
        return { row: row, col: column }
      end
    end
    nil
  end

  def column_full?(column)
    @grid[column].all?
  end

  def winning_move?(location, symbol)
    check_vertical(location, symbol) ||
    check_horizontal(location, symbol) ||
    check_diagonal(location, symbol)
  end

  def check_vertical(location, symbol)
    # Logic to check for 4 in a row vertically
    col = location[:col]
    row = location[:row]
    return false if row < 3 # Can't have a vertical win if the piece is too low

    # Check the 3 pieces below the one just placed
    (1..3).all? { |i| @grid[col][row - i] == symbol }
  end

  def check_horizontal(location, symbol)
    # For counting to the right: row changes by 0, column changes by +1
    count_right = count_in_direction(location, symbol, 0, +1)

    # For counting to the left: row changes by 0, column changes by -1
    count_left = count_in_direction(location, symbol, 0, -1)

    # The total is the piece itself (1) + pieces to the left and right
    total_count = 1 + count_left + count_right

    return total_count >= 4
  end

  def count_in_direction(location, symbol, row_change, col_change)
    consecutive_count = 0
    direction_name = "[row_change:#{row_change}, col_change:#{col_change}]" # For debugging

    current_row = location[:row] + row_change
    current_col = location[:col] + col_change

    while current_row.between?(0, 5) && current_col.between?(0, 6)
      if @grid[current_col][current_row] == symbol
        consecutive_count += 1
        current_row += row_change
        current_col += col_change
      else
        break
      end
    end

    puts "  - Found #{consecutive_count} pieces in direction #{direction_name}" # Debug message
    return consecutive_count
  end


  # Replace your check_diagonal method with this one.

  def check_diagonal(location, symbol)
    # Check 1: Upward Diagonal
    count1 = count_in_direction(location, symbol, +1, +1) # up-right
    count2 = count_in_direction(location, symbol, -1, -1) # down-left
    return true if 1 + count1 + count2 >= 4

    # Check 2: Downward Diagonal
    count3 = count_in_direction(location, symbol, -1, +1) # down-right
    count4 = count_in_direction(location, symbol, +1, -1) # up-left
    return true if 1 + count3 + count4 >= 4

    return false
  end

  # In board.rb
  def full?
    # The board is full if every spot in every column is not nil
    @grid.all? { |column| column.all? }
  end
end
