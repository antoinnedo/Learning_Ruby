class Board
  # update the board
  def print_board
    @board.each_with_index do |row, index|
      # map the array row by row and vertical divider
      puts ' ' + row.map { |cell| cell || ' ' }.join(' | ')

      # print horizontal divider
      print '-' * 4 * @size + "\n" if index < @board.size - 1
    end
  end
end
