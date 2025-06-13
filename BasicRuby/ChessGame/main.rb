# ChessGame/main.rb

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'game'
require 'byebug'

loop do
  # (A) Create a fresh Game instance for each new round
  game = Game.new
  game.play # This runs one full game

  # (B) This is a dedicated loop for input validation
  answer = nil # Initialize answer to nil
  loop do
    puts "\nPlay again? (y/n)"
    answer = gets.chomp.downcase

    # Break this inner loop ONLY if the input is valid
    break if ['y', 'n'].include?(answer)

    # If the input is invalid, print an error and the loop repeats
    puts "Invalid input. Please enter 'y' or 'n'."
  end

  # (C) Break the outer "play again" loop if the answer was 'n'
  break if answer == 'n'
end

puts "\nThanks for playing!"

##missing: en passant, castling, save game.
