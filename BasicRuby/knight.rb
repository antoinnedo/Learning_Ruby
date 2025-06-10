# ChessGame/lib/pieces/knight.rb
require_relative '../piece'

class Knight < Piece
  # accessed by calling Knight::POSSIBLE_MOVES
  POSSIBLE_MOVES = [
    [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2]
  ].freeze

  def moves(board)
    possible_moves = []
    # Get the knight's current position from the inherited @position variable.
    current_row, current_col = position

    POSSIBLE_MOVES.each do |row_offset, col_offset|
      # Calculate the potential new position by adding the offset.
      new_row = current_row + row_offset
      new_col = current_col + col_offset

      # Add the move to our list only if it's within the board's 8x8 grid.
      if new_row.between?(0, 7) && new_col.between?(0, 7)
        possible_moves << [new_row, new_col]
      end
    end

    possible_moves
  end

  # This provides a visual representation for the piece when displaying the board.
  # It returns the white unicode knight or the black one based on its color.
  def to_s
    color == :white ? '♞' : '♘'
  end
end
