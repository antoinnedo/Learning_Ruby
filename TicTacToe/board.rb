class Board
  # update the board
  attr_accessor :size

  def initialize
    @size = 3
    @board = create_grid_with_slice(3, 3)
  end

  #create 1 - size array then slice it into rows and columns

  def create_grid_with_slice(rows, cols)
    # Create a range from 1 to the total number of cells
    (1..(rows * cols)).to_a.each_slice(cols).to_a
  end

  def display
    @board.each_with_index do |row, index|
      # map the array row by row and vertical divider
      puts ' ' + row.map { |cell| cell || ' ' }.join(' | ')

      # print horizontal divider
      print '-' * 4 * 3 + "\n" if index < @board.size - 1
    end
  end

  def []=(position, marker)
    row, column = position_to_coords(position)
    @board[row][column] = marker
  end

  def position_to_coords(position)
    [(position - 1) / @size, (position - 1) % @size]
  end

  def available_positions
    positions = []
    @board.each_with_index do |row, r_index|
      row.each_with_index do |cell, c_index|
        positions << (r_index * @size + c_index + 1) if cell.is_a?(Integer)
      end
    end
    positions
  end

    # Checks for a winner
  def winner?(marker)
    check_rows(marker) || check_columns(marker) || check_diagonals(marker)
  end

  # Checks if the board is full
  def full?
    available_positions.empty?
  end

  private

  def check_rows(marker)
    @board.any? { |row| row.all? { |cell| cell == marker } }
  end

  def check_columns(marker)
    @board.transpose.any? { |col| col.all? { |cell| cell == marker } }
  end

  def check_diagonals(marker)
    diagonal1 = (0...@size).all? { |i| @board[i][i] == marker }
    diagonal2 = (0...@size).all? { |i| @board[i][@size - 1 - i] == marker }
    diagonal1 || diagonal2
  end
end
