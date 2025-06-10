# game.rb

require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new("Player 1", "\u26AA") # White circle symbol
    @player2 = Player.new("Player 2", "\u26AB") # Black circle symbol
    @current_player = @player1
  end

  def play
    loop do
      @board.display
      puts "#{@current_player.name}, choose a column (1-7):"

      column = get_player_input

      location = @board.drop_piece(column, @current_player.symbol)

      if location
        # Check for a win
        if @board.winning_move?(location, @current_player.symbol)
          @board.display
          puts "Congratulations, #{@current_player.name}! You win!"
          break
        end

        if @board.full?
          puts "It's a draw!"
          break
        end

        # Check for a draw (if the board is full)
        # CHALLENGE: Implement draw logic here

        # Switch to the next player
        switch_player
      else
        puts "That column is full! Please try another one."
      end
    end
  end

  private

  def get_player_input
    loop do
      input = gets.chomp.to_i - 1 # Subtract 1 to match array indexing (0-6)

      if input.between?(0, 6) && !@board.column_full?(input)
        return input
      else
        puts "Invalid input. Please enter a number between 1 and 7 for a non-full column."
      end
    end
  end

  def switch_player
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end
end
