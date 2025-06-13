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
    @history = {} # NEW: To track board states for threefold repetition
    @halfmove_clock = 0 #counter for 50 move rule
  end

  # This is the main game loop, which continues until the game is over.
  def play
    loop do
      # 1. Display the current state of the board.
      @board.display

      # Check for Checkmate (Win condition)
      if checkmate?(@current_player.color)
        # The previous player made the winning move.
        opponent = @current_player.color == :white ? 'Black' : 'White'
        puts "Checkmate! #{opponent} wins!"
        break
      # Check for Stalemate (Draw condition)
      elsif stalemate?(@current_player.color)
        puts "Draw by stalemate!"
        break
      # Check for Threefold Repetition (Draw condition)
      elsif @history[board_state_key] && @history[board_state_key] >= 3
        puts "Draw by threefold repetition!"
        break
      # Check for 50-Move Rule (Draw condition)
      elsif @halfmove_clock >= 100
        puts "Draw by 50-move rule!"
        break
      # Check for Insufficient Material (Draw condition)
      elsif @board.insufficient_material?
        puts "Draw by insufficient material!"
        break
      end

      puts "\nIt's #{@current_player.color}'s turn."

      # 2. Get a move from the current player.
      move = get_move


      # Allow the user to exit or resign
      break if move == 'exit' || move == 'resign'



      # 3. Process the move. If it's invalid, the loop continues and asks again.
      if process_move(move)
        # 4. If the move was successful, switch to the other player for the next turn.
        switch_player!
      end

      # (Future step: Check for checkmate or stalemate here)

    end
  end

  private

  def checkmate?(color)
    # 1. It can't be checkmate if the king isn't currently in check.
    return false unless @board.in_check?(color)

    # 2. Get all pieces belonging to the player in check.
    player_pieces = @board.pieces(color)

    # 3. Check if any of those pieces have any valid moves.
    # The 'none?' method returns true if the block never returns true for any element.
    # So, if none of the pieces have any valid moves, this will be true.
    player_pieces.none? do |piece|
      !piece.valid_moves(@board).empty?
    end
  end

  # You need a way to represent the board state as a unique key.
  # A simple string of piece positions and the current turn works well.
  def board_state_key
    state = ""
    @board.grid.flatten.each do |piece|
      state += piece ? "#{piece.class}-#{piece.color}-#{piece.position}" : "nil"
    end
    state += @current_player.color.to_s
    state
  end

  def stalemate?(color)
    # It can only be stalemate if the king is NOT in check.
    return false if @board.in_check?(color)

    # If any piece has at least one valid move, it's not stalemate.
    # This is the same logic as the second part of checkmate?.
    @board.pieces(color).all? do |piece|
      piece.valid_moves(@board).empty?
    end
  end

  # Asks the current player for input and converts it to board coordinates.
  def get_move
    loop do
      print "Enter your move in algebraic notation (e.g., 'e2e4'),"
      puts " type 'resign' to resign or type 'exit' to quit:"
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

  # Translates a single square from algebraic notation
  # (e.g., 'a1') to grid coordinates ([7, 0]).
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
    unless piece
      puts "Invalid move: There is no piece at the starting square."
      return false
    end
    unless piece.color == @current_player.color
      puts "Invalid move: You can only move your own pieces."
      return false
    end
    unless piece.valid_moves(@board).include?(end_pos)
      puts "Invalid move: That piece cannot perform that move."
      return false
    end

    @board.move_piece(start_pos, end_pos)

    moved_piece = @board.piece_at(end_pos)
    if moved_piece.is_a?(Pawn) && (end_pos[0] == 0 || end_pos[0] == 7)
      # *** THIS IS WHEN YOU CALL IT ***
      promote_pawn(end_pos, moved_piece.color)
    end

    piece.moved!

    # Update history for threefold repetition
    key = board_state_key
    @history[key] = @history.fetch(key, 0) + 1

    true
  end

  def promote_pawn(position, color)
    row, col = position
    color = @current_player.color

    print "Enter 'Q' for Queen, 'R' for Rook,"
    puts " 'B' for Bishop, or 'N' for Knight."

    choice = nil
    loop do
      choice = gets.chomp.upcase
      break if ['Q', 'R', 'B', 'N'].include?(choice)
      puts "Invalid choice. Please enter Q, R, B, or N."
    end

    new_piece_class = case choice
                          when 'Q' then Queen
                          when 'R' then Rook
                          when 'B' then Bishop
                          when 'N' then Knight
                          end

    new_piece = new_piece_class.new(color, position)
    @board.grid[position[0]][position[1]] = new_piece
    puts "Pawn promoted to a #{new_piece_class.to_s.downcase}."
  end

  # Switches the @current_player to the other player.
  def switch_player!
    @current_player = (@current_player == @player1) ? @player2 : @player1
  end
end
