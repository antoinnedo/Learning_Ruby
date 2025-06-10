# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/board.rb
class Board
  def initialize
    @history = [] # Stores { guess: [], feedback: [] }
  end

  def add_to_history(guess, feedback_array)
    @history << { guess: guess, feedback: feedback_array }
  end

  def print_game_summary(secret_code)
    puts "\n" + "=" * 50
    puts " " * 18 + "GAME SUMMARY"
    puts "=" * 50
    puts "Secret Code was: |" + secret_code.join('|') + "|"
    puts "-" * 50
    if @history.empty?
      puts "No guesses were made."
    else
      @history.each_with_index do |item, index|
        guess_str = "|" + item[:guess].join('|') + "|"
        feedback_str = "[" + item[:feedback].join(', ') + "]"
        puts "Turn #{index + 1}: #{guess_str} -> Feedback: #{feedback_str}"
      end
    end
    puts "=" * 50 + "\n"
  end
end
