# frozen_string_literal: true

class Game
  def initialize
    @bot_symbol = ''
    @human_symbol = ''
    @size = 0
    @board = []
    @loop_count = 0
  end

  def set_up
    loop do
      puts 'X or O?'
      input_symbol = gets.chomp.upcase
      if %w[X O].include?(input_symbol)
        @human_symbol = input_symbol
        if @human_symbol == 'X'
          @bot_symbol = 'O'
        else
          @bot_symbol = 'X'
        break
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

  def valid_move?(row, column)
    return false unless row.is_a?(Integer) && column.is_a?(Integer)
    return false unless row.between?(0, @size - 1) && column.between?(0, @size - 1)
    @board[row][column].nil?
  end

  def get_move
    loop do
      puts "Your move:"
      input_str = gets.chomp
      unless input_str.match?(/^\d+\s\d+$/)
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

  def board_full?
    @loop_count == @size * @size
  end

  def print_board
    @board.each_with_index do |row, index|
      puts ' ' + row.map { |cell| cell || ' ' }.join(' | ')
      print '-' * 4 * @size + "\n" if index < @board.size - 1
    end
  end

  def get_bot_move

  end

  def start
    set_up
    loop do
      print_board
      get_move
      if winner?
        puts 'You won.'
        break
      elsif board_full?
        puts 'Tie.'
        break
      end
    end
  end
end

new_game = Game.new

new_game.print_board

new_game.start
