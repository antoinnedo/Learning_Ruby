require_relative './game.rb'

class Game
  # constructor
  def initialize
    @bot_symbol = ''
    @human_symbol = ''
    @loop_count = 0
  end

  def win_in_rows?
    @board.any? { |row| row.all? { |cell| cell == @human_symbol}}
  end

  def win_in_columns?
    @board.any? { |column| column.all? { |cell| cell == @human_symbol}}
  end

  def win_in_diagonals?
    diagonal1 = (0...@size).all? { |i| @board[i][i] == @human_symbol }
    diagonal2 = (0...@size).all? { |i| @board[i][-i-1] == @human_symbol }
    diagonal1 || diagonal2
  end

  def winner?
    win_in_rows? ||
    win_in_columns? ||
    win_in_diagonals?
  end

  def set_up
    loop do
      puts 'X or O?'
      input_symbol = gets.chomp.upcase
      if %w[X O].include?(input_symbol)
        @human_symbol = input_symbol
        if @human_symbol == 'X'
          @bot_symbol = 'O'
        elsif @human_symbol == 'O'
          @bot_symbol = 'X'
          break
        end
      else
        puts 'Invalid input. X or O?'
      end
    end
    loop do
      puts 'Board size?'
      input_size_str = gets.chomp
      if input_size_str.match?(/\A\d+\z/)
        s = input_size_str.to_i
        if s >= 3
          @size = s
          break
        else
          puts 'Invalid size. Must be at least 3.'
        end
      else
        puts 'Invalid input. Enter an integer.'
      end
    end

    # Initialize board and loop_count now that @size is known
    @board = Array.new(@size) { Array.new(@size) } # Cells are nil initially
    @loop_count = 0
    puts "Game set up: Player is '#{@human_symbol}', Board size is #{@size}x#{@size}."
  end
end
