require_relative 'board.rb'
require_relative 'player.rb'

class Game
  # constructor
  def initialize
    @board = Board.new
    @player1 = Player.new(nil, 'Player 1', 1)
    @player2 = Player.new(nil, 'Player 2', 2)
    @current_player = @player1
  end

  def play
    set_up_players
    @board.display

    loop do
      play_turn
      break if game_over?
      switch_players
    end

    display_result
  end

  def switch_players
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end

  def get_move
    loop do
      print "Enter position (1 - #{@board.size**2}): "
      input = gets.chomp.to_i

      if input.between?(1, @board.size**2) && @board.available_positions.include?(input)
        return input
      end
      puts "Invalid position!"
    end
  end

  def play_turn
    puts "#{@current_player.name}'s turn)"
    position = get_move
    @board[position] = @current_player.marker
    @board.display
  end

  def set_up_players
    puts "Let's set up the players."

    # Player 1 Marker Selection
    loop do
      print "Choose marker for Player 1: "
      marker1 = gets.chomp
      if marker1.length == 1
        @player1.marker = marker1
        break
      else
        puts "Invalid marker. Please choose a single character."
      end
    end

    # Player 2 Marker Selection
    loop do
      print "Choose marker for Player 2: "
      marker2 = gets.chomp
      if marker2.length == 1
        if marker2 != @player1.marker
          @player2.marker = marker2
          break
        else
          puts "Marker must be different from Player 1's ('#{@player1.marker}')."
        end
      else
        puts "Invalid marker. Please choose a single character."
      end
    end
  end

  def game_over?
    winner? || @board.full?
  end

  def winner?
    @board.winner?(@current_player.marker)
  end

  def display_result
    if winner?
      puts "Congratulations #{@current_player.name}, you win!"
    elsif @board.full?
      puts "It's a draw!"
    end
  end
end
