# ChessGame/lib/pieces/bishop.rb

require_relative '../piece'

class Bishop < Piece
  # A bishop moves along the four diagonal directions.
  MOVE_DIRECTIONS = [
    [1, 1],   # Down-Right
    [1, -1],  # Down-Left
    [-1, 1],  # Up-Right
    [-1, -1]  # Up-Left
  ].freeze

  # This `moves` method is identical in logic to the Rook's.
  # It takes the board state to check for obstacles in its path.
  def moves(board)
    possible_moves = []
    current_row, current_col = position

    # Iterate through each of the 4 diagonal directions
    MOVE_DIRECTIONS.each do |row_offset, col_offset|
      next_row = current_row + row_offset
      next_col = current_col + col_offset

      # Keep moving in one direction until you hit an obstacle or the edge
      while board.on_board?([next_row, next_col])
        destination_square = board.piece_at([next_row, next_col])

        if destination_square.nil?
          possible_moves << [next_row, next_col]
        elsif destination_square.color != self.color
          possible_moves << [next_row, next_col] # Valid capture
          break
        else
          break # Blocked by a friendly piece
        end

        next_row += row_offset
        next_col += col_offset
      end
    end

    possible_moves
  end

  def to_s
    color == :white ? '♝' : '♗'
  end
end
