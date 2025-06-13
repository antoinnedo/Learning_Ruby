# lib/board.rb

# This line dynamically requires all piece files from the pieces directory.
# Note: This approach has a slight issue where it might not find the base 'piece.rb'
# if it's not loaded first. Explicit requires in game.rb are safer.
# Dir.glob(File.join(__dir__, 'pieces', '*.rb')).each { |file| require file }

class Board
  attr_reader :grid


  def initialize
    # The grid is an 8x8 array. We'll fill it with nil initially,
    # then populate it with Piece objects.
    @grid = Array.new(8) { Array.new(8) }

    setup_board
  end

  # Returns the piece object at a given position.
  # pos: An array like [row, col] (e.g., [0, 0])
  def piece_at(pos)
    row, col = pos
    return nil unless on_board?(pos) # Guard against out-of-bounds queries
    @grid[row][col]
  end

  # Moves a piece from a starting position to an end position.
  # This method does not perform move validation; that is the Game's job.
  def move_piece(start_pos, end_pos)
    piece_to_move = piece_at(start_pos)
    return unless piece_to_move # Should not happen if Game validates first

    if piece_to_move.is_a?(King) && (end_pos[1] - start_pos[1]).abs == 2
      # Kingside castle
      if end_pos[1] > start_pos[1]
        rook_start_pos = [start_pos[0], 7]
        rook_end_pos = [start_pos[0], 5]
      # Queenside castle
      else
        rook_start_pos = [start_pos[0], 0]
        rook_end_pos = [start_pos[0], 3]
      end

      rook = piece_at(rook_start_pos)
      # Move the rook
      @grid[rook_end_pos[0]][rook_end_pos[1]] = rook
      @grid[rook_start_pos[0]][rook_start_pos[1]] = nil
      rook.position = rook_end_pos
      rook.moved!
    end

    # Update the piece's internal position tracker
    piece_to_move.position = end_pos

    # Place the piece object in the new square on the grid
    @grid[end_pos[0]][end_pos[1]] = piece_to_move

    # Clear the old square
    @grid[start_pos[0]][start_pos[1]] = nil
  end

  # Checks if a given position is within the board's 8x8 boundaries.
  def on_board?(pos)
    row, col = pos
    row.between?(0, 7) && col.between?(0, 7)
  end

  # Displays a visual representation of the board in the console.
  def display
    puts
    puts "    a   b   c   d   e   f   g   h"
    puts "  +---+---+---+---+---+---+---+---+" # Top border
    @grid.each_with_index do |row, row_idx|
      # Print the row number and the opening pipe
      print "#{8 - row_idx} |"

      # Print each square with its content and a closing pipe
      row.each do |square|
        print " #{square || ' '} |"
      end

      # Print the row number again at the end of the line
      puts " #{8 - row_idx}"

      # Print the horizontal divider between rows
      puts "  +---+---+---+---+---+---+---+---+"
    end
    puts "    a   b   c   d   e   f   g   h"
    puts
  end

  def pieces(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  # NEW: Checks if a player of a given color is in check.
  def in_check?(color)
    # 1. Find the position of that color's king.
    king_pos = find_king(color)
    return false unless king_pos # Should not happen in a real game

    # 2. Check if any opponent piece can attack that square.
    opponent_color = (color == :white) ? :black : :white
    pieces(opponent_color).any? do |piece|
      # Note: We use the basic `moves` method here, not `valid_moves`,
      # to avoid an infinite loop of checks.
      piece.moves(self).include?(king_pos)
    end
  end


  #Creates a deep copy of the board and its pieces for move simulation.
  def dup
    new_board = Board.new

    # Create a new grid and fill it with duplicates of the original pieces
    new_grid = @grid.map do |row|
      row.map do |piece|
        piece ? piece.dup : nil # Duplicate each piece, or keep nil
      end
    end

    new_board.instance_variable_set(:@grid, new_grid)
    return new_board
  end

  # Helper method to find the position of a king.
  def find_king(color)
    @grid.each_with_index do |row, r_idx|
      row.each_with_index do |piece, c_idx|
        if piece.is_a?(King) && piece.color == color
          return [r_idx, c_idx]
        end
      end
    end
    nil # King not found
  end

  def insufficient_material?
    # Get a list of all pieces except kings
    pieces_left = @grid.flatten.compact.reject { |p| p.is_a?(King) }

    # Case 1: King vs King (no other pieces left)
    return true if pieces_left.empty?

    # Case 2: King vs King + one minor piece (Knight or Bishop)
    if pieces_left.length == 1 && (pieces_left.first.is_a?(Knight) || pieces_left.first.is_a?(Bishop))
      return true
    end
    false
  end

  private

  # Sets up the board with all 32 pieces in their standard starting positions.
  def setup_board
    # --- Black Pieces (Top of the board: Rows 0 and 1) ---
    @grid[0] = [
      Rook.new(:black, [0, 0]), Knight.new(:black, [0, 1]), Bishop.new(:black, [0, 2]),
      Queen.new(:black, [0, 3]), King.new(:black, [0, 4]), Bishop.new(:black, [0, 5]),
      Knight.new(:black, [0, 6]), Rook.new(:black, [0, 7])
    ]
    (0..7).each { |col| @grid[1][col] = Pawn.new(:black, [1, col]) }

    # --- White Pieces (Bottom of the board: Rows 6 and 7) ---
    (0..7).each { |col| @grid[6][col] = Pawn.new(:white, [6, col]) }
    @grid[7] = [
      Rook.new(:white, [7, 0]), Knight.new(:white, [7, 1]), Bishop.new(:white, [7, 2]),
      Queen.new(:white, [7, 3]), King.new(:white, [7, 4]), Bishop.new(:white, [7, 5]),
      Knight.new(:white, [7, 6]), Rook.new(:white, [7, 7])
    ]

    # @grid[0][5] = King.new(:black, [0, 5])
    # @grid[7][5] = King.new(:white, [7, 5])
  end
end
