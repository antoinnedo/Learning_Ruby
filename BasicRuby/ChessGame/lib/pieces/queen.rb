# ChessGame/lib/pieces/queen.rb

require_relative '../piece'

class Queen < Piece
  # The Queen's movement is the sum of the Rook's and Bishop's movements.
  # We combine their direction vectors into one constant.
  MOVE_DIRECTIONS = [
    # Rook Directions (Straight)
    [0, 1], [0, -1], [1, 0], [-1, 0],
    # Bishop Directions (Diagonal)
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ].freeze

  # The logic is again identical to the Rook and Bishop. It just iterates
  # over all 8 directions instead of 4.
  def moves(board)
    possible_moves = []
    current_row, current_col = position

    MOVE_DIRECTIONS.each do |row_offset, col_offset|
      next_row = current_row + row_offset
      next_col = current_col + col_offset

      while board.on_board?([next_row, next_col])
        destination_square = board.piece_at([next_row, next_col])

        if destination_square.nil?
          possible_moves << [next_row, next_col]
        elsif destination_square.color != self.color
          possible_moves << [next_row, next_col]
          break
        else
          break
        end

        next_row += row_offset
        next_col += col_offset
      end
    end

    possible_moves
  end

  def to_s
    color == :white ? '♛' : '♕'
  end
end
