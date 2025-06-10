class Player

  def get_player_move
    loop do
      puts "Your move:"
      input_str = gets.chomp
      unless input_str.match?(/^\d+\s\d+$/) # verify input
        puts "Invalid input. Try 'row column'."
        next
      end

      row, column = input_str.split(' ').map(&:to_i)

      if valid_move?(row, column)
        @board[row][column] = @human_symbol
        @loop_count += 1
        break
      else
        puts "Invalid move. Try again."
      end
    end
  end
end
