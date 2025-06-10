# ChessGame/lib/piece.rb

class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(color, position = nil)
    unless [:white, :black].include?(color)
      raise ArgumentError, "Color must be :white or :black"
    end

    @color = color
    @position = position # A piece might store its own position, or the board does
  end

  # This method will be overridden by specific piece types
  # It should return an array of all possible *relative* moves
  # from a given square, NOT considering the board boundaries or other pieces.
  def moves(board)
    raise NotImplementedError, "Subclasses must implement the 'moves' method."
  end

  # This method might be implemented here or in Board.
  # It checks if a move is valid given the board.
  # For now, we'll assume the Board handles `on_board?` and collision detection.
  # def valid_moves(current_pos, board)
  #   # Logic to combine Piece-specific moves with board validation
  # end

  def to_s
    # This is for displaying the piece, e.g., '♞' for black knight
    # You'd typically use unicode chess symbols or single letters.
    # We'll make this concrete in Knight.
  end
end
