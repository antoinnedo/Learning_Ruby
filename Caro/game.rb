require_relative 'board'
require_relative 'player'
require_relative 'bot'

class Game
  # constructor
  def initialize
    @bot_symbol = ''
    @human_symbol = ''
    @size = 0
    @board = []
    @loop_count = 0
  end

  #check if move is not and integer or
  def valid_move?(row, column)
    return false unless row.is_a?(Integer) && column.is_a?(Integer)
    return false unless row.between?(0, @size - 1) && column.between?(0, @size - 1)
    @board[row][column].nil?
  end

  # pick symbol and size
  def set_up
    # pick symbol
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

    # pick size
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

  #start the whole game
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
