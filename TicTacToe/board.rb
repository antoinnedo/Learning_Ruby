class Board
  # update the board

  def initialize
    @board = [[1, 2, 3], [4, 5, 6], [7,8,9]]
  end

  def print_board
    @board.each_with_index do |row, index|
      # map the array row by row and vertical divider
      puts ' ' + row.map { |cell| cell || ' ' }.join(' | ')

      # print horizontal divider
      print '-' * 4 * 3 + "\n" if index < @board.size - 1
    end
  end
end

new_board = Board.new
new_board.print_board
