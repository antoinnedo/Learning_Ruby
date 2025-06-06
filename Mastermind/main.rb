# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/main.rb
require_relative 'player'
require_relative 'board'
require_relative 'colors'

class Main
  def initialize
    @board = Board.new
    @turns_taken = 0
    @game_over = false
    @code_length = 4 # Default, will be set by user
    @max_turns = 12  # Default, will be set by user
    @secret_code = []
  end

  def setup_game
    puts "Welcome to Mastermind!"

    # Get desired code length
    loop do
      print "Enter the desired length of the secret code (e.g., 4): "
      input = gets.chomp
      if input.match?(/^\d+$/) && input.to_i > 0
        @code_length = input.to_i
        if @code_length > Colors::VALID_COLORS.length
            puts "Code length cannot exceed the number of available unique colors (#{Colors::VALID_COLORS.length})."
        else
            break
        end
      else
        puts "Invalid input. Please enter a positive number for code length."
      end
    end

    # Get desired number of turns
    loop do
      print "Enter the maximum number of turns you want (e.g., 12): "
      input = gets.chomp
      if input.match?(/^\d+$/) && input.to_i > 0
        @max_turns = input.to_i
        break
      else
        puts "Invalid input. Please enter a positive number for turns."
      end
    end

    @secret_code = Colors.generate_secret_code(@code_length)
    puts "A secret code of #{@code_length} colors has been generated."
    puts "You have #{@max_turns} turns to guess it." # Use instance variable
    puts "Feedback: BLACK = Correct Color & Position, WHITE = Correct Color, Wrong Position, EMPTY = Incorrect Color."
    puts "The order of feedback pegs directly corresponds to your guess order."
    # puts "DEBUG: Secret code is #{@secret_code.join(' ')}" # Uncomment for debugging
  end

  def calculate_ordered_feedback(guess)
    feedback = Array.new(@code_length, "EMPTY") # Initialize feedback with "EMPTY"

    temp_secret = @secret_code.dup
    temp_guess = guess.dup

    # First pass: Check for BLACK pegs (correct color, correct position)
    (0...@code_length).each do |i|
      if temp_guess[i] == temp_secret[i]
        feedback[i] = "BLACK"
        temp_secret[i] = nil
        temp_guess[i] = nil
      end
    end

    # Second pass: Check for WHITE pegs (correct color, wrong position)
    (0...@code_length).each do |i|
      next if temp_guess[i].nil?

      secret_idx = temp_secret.index(temp_guess[i])
      if secret_idx
        feedback[i] = "WHITE"
        temp_secret[secret_idx] = nil
      end
    end
    feedback
  end

  def start
    setup_game

    until @game_over || @turns_taken >= @max_turns # Use instance variable
      turns_left = @max_turns - @turns_taken # Use instance variable
      puts "\n--- Turn #{@turns_taken + 1}/#{@max_turns} (Turns left: #{turns_left}) ---" # Use instance variable

      current_guess = Player.get_move(@code_length)
      @turns_taken += 1

      feedback_array = calculate_ordered_feedback(current_guess)
      @board.add_to_history(current_guess, feedback_array)

      puts "Your Guess: |#{current_guess.join('|')}|"
      puts "Feedback:   [#{feedback_array.join(', ')}]"

      if feedback_array.all? { |peg| peg == "BLACK" }
        @game_over = true
        puts "\nCongratulations! You guessed the code in #{@turns_taken} turns!"
      elsif @turns_taken >= @max_turns # Use instance variable
        @game_over = true
        puts "\nGame Over! You ran out of turns."
      end
    end
    @board.print_game_summary(@secret_code)
  end
end

# Start the game
new_game = Main.new
new_game.start
