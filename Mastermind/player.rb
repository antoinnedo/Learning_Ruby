require_relative 'main'
require_relative 'colors'

#taking player's input

class Player
  def get_move
    loop do
      puts "Your move:"
      input_str = gets.chomp.split(' ').map()
      unless input_str.each do { |color| Colors.valid_colors.include?(color) }
        puts 'Invalid color.', 'Try only these:', "'blue', 'red', 'green', 'yellow', 'violet', 'black', 'white'."
      end
    end
    input_str
  end
end
