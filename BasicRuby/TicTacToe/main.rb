require_relative 'game'

def start_game
  puts "Welcome to Tic Tac Toe!"
  Game.new.play

  loop do
    print "Play again? (y/n): "
    answer = gets.chomp.downcase
    if answer == 'y'
      Game.new.play
    elsif answer == 'n'
      break
    end
  end

  puts "Thanks for playing!"
end

start_game
