# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/board.rb
class Board
  def initialize
    @guesses_history = [] # To store { guess: [], feedback: {} }
  end

  def add_guess(guess, feedback)
    @guesses_history << { guess: guess, feedback: feedback }
  end

  def print_board(turns_left)
    puts "\n" + "=" * 40
    puts " " * 10 + "MASTERMIND BOARD"
    puts "=" * 40
    puts "Turns left: #{turns_left}"
    puts "-" * 40
    if @guesses_history.empty?
      puts "No guesses made yet."
    else
      @guesses_history.each_with_index do |item, index|
        guess_str = item[:guess].join(' | ')
        feedback_str = "Correct Positions: #{item[:feedback][:correct_position]}, Correct Colors: #{item[:feedback][:correct_color_wrong_position]}"
        puts "Turn #{index + 1}: #{guess_str} -> #{feedback_str}"
      end
    end
    puts "=" * 40 + "\n"
  end
end
