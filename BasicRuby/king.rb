# ChessGame/lib/pieces/king.rb

require_relative '../piece'

class King < Piece
  # The King can move one square in any of the 8 directions.
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],  # Straight
    [1, 1], [1, -1], [-1, 1], [-1, -1] # Diagonal
  ].freeze

  # The `moves` method for the King is simpler than sliding pieces.
  # It checks each of the 8 adjacent squares.
  # Note: This method does NOT check if a move would place the King in check.
  # That complex logic is better handled by the Game or Board class after
  # getting this initial list of possible moves.
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

    # Castling is a special move and will be handled separately.
    possible_moves
  end

  def to_s
    color == :white ? '♚' : '♔'
  end
end
