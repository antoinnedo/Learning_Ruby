# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/player.rb
require_relative 'colors'

class Player
  def self.get_move(code_length)
    loop do
      puts "\nEnter your guess (#{code_length} colors, space-separated):"
      puts "(Valid: #{Colors::VALID_COLORS.join(', ')})"
      print "> "
      input_str = gets.chomp.upcase.split(' ')

      if input_str.length != code_length
        puts "Incorrect number of colors. Please enter #{code_length} colors."
        next
      end

      if input_str.all? { |color| Colors::VALID_COLORS.include?(color) }
        return input_str
      else
        invalid_colors = input_str.reject { |color| Colors::VALID_COLORS.include?(color) }
        puts "Invalid color(s) detected: #{invalid_colors.join(', ')}. Please use only the valid colors."
      end
    end
  end
end
