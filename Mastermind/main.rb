# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/main.rb
require_relative 'player'
require_relative 'board'
require_relative 'colors'

class Main
  def initialize
    @board = Board.new
    @secret_code = Colors.sample_code
    @turns_taken = 0
    @game_over = false
  end

  def calculate_feedback(guess)
    correct_position = 0
    correct_color_wrong_position = 0

    temp_secret_code = @secret_code.dup
    temp_guess = guess.dup

    # First pass: Check for correct color in correct position (black pegs)
    temp_guess.each_with_index do |color, index|
      if color == temp_secret_code[index]
        correct_position += 1
        temp_guess[index] = nil      # Mark as checked
        temp_secret_code[index] = nil # Mark as checked
      end
    end

    # Second pass: Check for correct color in wrong position (white pegs)
    temp_guess.compact! # Remove nils
    temp_secret_code.compact! # Remove nils

    temp_guess.each do |color|
      if temp_secret_code.include?(color)
        correct_color_wrong_position += 1
        temp_secret_code.delete_at(temp_secret_code.index(color)) # Remove matched color to avoid re-counting
      end
    end

    { correct_position: correct_position, correct_color_wrong_position: correct_color_wrong_position }
  end

  def display_welcome_message
    puts "Welcome to Mastermind!"
    puts "The computer has generated a secret code of #{Colors::CODE_LENGTH} colors."
    puts "You have #{Colors::MAX_TURNS} turns to guess it."
    puts "Feedback is given as:"
    puts "  - Correct Positions: Number of colors that are correct and in the right spot."
    puts "  - Correct Colors: Number of colors that are correct but in the wrong spot."
    puts "Let's begin!"
  end

  def start
    display_welcome_message
    # puts "DEBUG: Secret code is #{@secret_code.join(' ')}" # Uncomment for debugging

    until @game_over || @turns_taken >= Colors::MAX_TURNS
      turns_left = Colors::MAX_TURNS - @turns_taken
      @board.print_board(turns_left)

      current_guess = Player.get_move
      @turns_taken += 1

      feedback = calculate_feedback(current_guess)
      @board.add_guess(current_guess, feedback)

      if feedback[:correct_position] == Colors::CODE_LENGTH
        @game_over = true
        @board.print_board(0) # Show final board state
        puts "Congratulations! You guessed the code: #{@secret_code.join(' ')} in #{@turns_taken} turns!"
      elsif @turns_taken >= Colors::MAX_TURNS
        @board.print_board(0) # Show final board state
        puts "Game Over! You ran out of turns."
        puts "The secret code was: #{@secret_code.join(' ')}"
      end
    end
  end
end

# Start the game
new_game = Main.new
new_game.start
