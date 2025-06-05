require_relative 'player'
require_relative 'main'

class Logic
  def win?
    puts 'You won. Yippi!' if Player.get_move ==  new_game.key

    player_guess = Player.get_move

    player_guess.each_with_index do |index|
      unless player_guess[index] == @@key
      end
  end
end
