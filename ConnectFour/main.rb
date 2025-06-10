# main.rb

require_relative 'game'

loop do
  # Create a new game instance for each playthrough
  game = Game.new
  game.play # This will run until a win or draw

  puts "\nPlay again? (y/n)"
  answer = gets.chomp.downcase

  # If the answer is anything other than 'y', exit the loop.
  break unless answer == 'y'
end

puts "Thanks for playing!"
