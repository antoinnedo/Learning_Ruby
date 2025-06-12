# ChessGame/lib/pieces/king.rb

require_relative '../piece'

class King < Piece
  # The King can move one square in any of the 8 directions.
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],  # Straight
    [1, 1], [1, -1], [-1, 1], [-1, -1] # Diagonal
  ].freeze

  def moves(board)
    possible_moves = []
    current_row, current_col = position

    MOVE_DIRECTIONS.each do |row_offset, col_offset|
      # Calculate the potential new position (only one step away)
      new_row = current_row + row_offset
      new_col = current_col + col_offset
      new_pos = [new_row, new_col]

      # Check if the new position is on the board
      next unless board.on_board?(new_pos)

      destination_square = board.piece_at(new_pos)

      # A King can move to an empty square or capture an enemy piece.
      # It cannot move to a square occupied by a friendly piece.
      if destination_square.nil? || destination_square.color != self.color
        possible_moves << new_pos
      end
    end

    # Castling is handled somewhere else
    possible_moves
  end

  def to_s
    color == :white ? '♚' : '♔'
  end
end
