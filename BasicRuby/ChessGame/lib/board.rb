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
    puts "    a  b  c  d  e  f  g  h"
    puts "  +------------------------+"
    @grid.each_with_index do |row, row_idx|
      print "#{8 - row_idx} |"
      # And change this loop:
      row.each_with_index do |square, col_idx| # Use each_with_index
        # To calculate the background like this:
        background = (row_idx + col_idx) % 2 == 0 ? :light_blue : :light_black
        print " #{square || ' '} ".ljust(3)
      end
      puts "| #{8 - row_idx}"
    end
    puts "  +------------------------+"
    puts "    a  b  c  d  e  f  g  h"
    puts
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
  end
end
