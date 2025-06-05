# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/player.rb
require_relative 'colors'

class Player
  def self.get_move
    loop do
      puts "Enter your guess: #{Colors::CODE_LENGTH} colors separated by spaces."
      puts "Valid colors are: #{Colors::VALID_COLORS.join(', ')}"
      print "> "
      input_str = gets.chomp.upcase.split(' ')

      if input_str.length != Colors::CODE_LENGTH
        puts "Incorrect number of colors. Please enter #{Colors::CODE_LENGTH} colors."
        next
      end

      if input_str.all? { |color| Colors::VALID_COLORS.include?(color) }
        return input_str
      else
        puts "Invalid color(s) detected. Please use only the valid colors."
      end
    end
  end
end
