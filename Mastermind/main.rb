require_relative 'player'
require_relative 'bot'
require_relative 'board'

class Main

  def initialize
    @key = []
  end

  def start
    set_up
    loop do
      Board.print_board
      Player.get_move
      if winner?
        puts 'You won.'
        break
      elsif board_full?
        puts 'Tie.'
        break
      end
    end
  end
end

new_game = Main.new
