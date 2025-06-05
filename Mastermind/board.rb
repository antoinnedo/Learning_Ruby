# print board and update board

class Board
  attr_accessor :size, :correct_squares

  def initialize(size)
    @board = Array.new(size) { rand(size) }
    @size = size
    @correct_squares = 0
  end

  def print_board
    puts '|' + (@board.map { |cell| cell || '  ' }.join('|')) + '|'
  end
end

Board.new(5).print_board
