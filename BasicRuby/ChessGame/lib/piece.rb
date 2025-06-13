# ChessGame/lib/piece.rb

class Piece
  attr_reader :color, :has_moved
  attr_accessor :position

  def initialize(color, position = nil)
    unless [:white, :black].include?(color)
      raise ArgumentError, "Color must be :white or :black"
    end
    @has_moved = false
    @color = color
    @position = position # A piece might store its own position, or the board does
  end

  # This method will be overridden by specific piece types
  # It should return an array of all possible *relative* moves
  # from a given square, NOT considering the board boundaries or other pieces.
  def moves(board)
    raise NotImplementedError, "Subclasses must implement the 'moves' method."
  end

  def to_s
    #for putting piece as unicode symbol
  end

  def valid_moves(board)
    # Start with all theoretically possible moves for the piece
    all_moves = self.moves(board)

    # Filter out any move that would leave the king in check
    all_moves.reject do |end_pos|
      # Create a deep copy of the board to simulate the move
      duped_board = board.dup

      # Perform the move on the temporary board
      duped_board.move_piece(self.position, end_pos)

      # If the king is in check after the move, it's not a valid move
      duped_board.in_check?(self.color)
    end
  end

  def moved!
    @has_moved = true
  end
end
