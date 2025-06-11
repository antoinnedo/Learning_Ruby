# lib/game.rb

# Require all the necessary files for the game to run.
require_relative 'board'
require_relative 'player'
require_relative 'piece'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'

# The Game class is the main engine that orchestrates the entire chess game.
class Game
  def initialize
    # Create the board and the two players.
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)

    # Set the starting player. White always goes first.
    @current_player = @player1
  end

  # This is the main game loop, which continues until the game is over.
  def play
    loop do
      # 1. Display the current state of the board.
      @board.display
      puts "\nIt's #{@current_player.color}'s turn."

      # 2. Get a move from the current player.
      move = get_move

      # Allow the user to exit gracefully.
      break if move == 'exit'

      # 3. Process the move. If it's invalid, the loop continues and asks again.
      if process_move(move)
        # 4. If the move was successful, switch to the other player for the next turn.
        switch_player!
      end

      # (Future step: Check for checkmate or stalemate here)
      # if @board.checkmate?(@current_player.color)
      #   @board.display
      #   puts "Checkmate! #{(@current_player == @player1 ? @player2 : @player1).color} wins!"
      #   break
      # end
    end
  end

  private

  # Asks the current player for input and converts it to board coordinates.
  def get_move
    loop do
      puts "Enter your move in algebraic notation (e.g., 'e2e4'), or type 'exit' to quit:"
      input = gets.chomp.downcase

      return 'exit' if input == 'exit'

      if input == 'resign'
        opponent_color = (@current_player.color == :white) ? 'Black' : 'White'
        puts "#{@current_player.color.to_s.capitalize} has resigned. #{opponent_color} wins!"
        return 'resign' # Return a special value
      end

      # Validate the input format (e.g., a1b2). Must be 4 characters.
      if input.match?(/^[a-h][1-8][a-h][1-8]$/)
        # Convert algebraic notation like 'e2e4' to array coordinates [[6, 4], [4, 4]]
        start_pos = algebraic_to_coords(input[0..1])
        end_pos = algebraic_to_coords(input[2..3])
        return [start_pos, end_pos]
      else
        puts "Invalid format. Please use the format 'a1b2'."
      end
    end
  end

  # Translates a single square from algebraic notation (e.g., 'a1') to grid coordinates ([7, 0]).
  def algebraic_to_coords(alg_notation)
    col_char = alg_notation[0]
    row_char = alg_notation[1]

    # Map 'a'-'h' to 0-7 and '1'-'8' to 0-7.
    # Note: Chess rank '1' is board row 7, '8' is board row 0.
    col = col_char.ord - 'a'.ord
    row = 8 - row_char.to_i

    [row, col]
  end

  # Validates and executes a move. Returns true if successful, false otherwise.
  def process_move(move)
    start_pos, end_pos = move

    piece = @board.piece_at(start_pos)

    # --- Validation Checks ---
    # 1. Check if there's a piece at the starting position.
    unless piece
      puts "Invalid move: There is no piece at the starting square."
      return false
    end

    # 2. Check if the piece belongs to the current player.
    unless piece.color == @current_player.color
      puts "Invalid move: You can only move your own pieces."
      return false
    end

    # 3. Get all possible moves for that piece and check if the end position is one of them.
    # NOTE: All your piece 'moves' methods should accept the board as an argument.
    possible_moves = piece.moves(@board)
    unless possible_moves.include?(end_pos)
      puts "Invalid move: That piece cannot move to the destination square."
      return false
    end

    # (Future step: Check if the move would put the current player in check)

    # --- Execute the Move ---
    # If all checks pass, move the piece on the board.
    @board.move_piece(start_pos, end_pos)
    true
  end

  # Switches the @current_player to the other player.
  def switch_player!
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end
end
