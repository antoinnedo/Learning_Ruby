# ChessGame/lib/pieces/rook.rb

require_relative '../piece'

class Rook < Piece
  # A rook doesn't have a fixed set of moves, but a fixed set of directions.
  # It can move along these vectors repeatedly.
  MOVE_DIRECTIONS = [
    [0, 1],  # Right
    [0, -1], # Left
    [1, 0],  # Down
    [-1, 0]  # Up
  ].freeze

  def moves(board) # Note: The method now needs the board state to check for obstacles
    possible_moves = []
    current_row, current_col = position

    # Iterate through each of the 4 directions
    MOVE_DIRECTIONS.each do |row_offset, col_offset|
      # Start exploring from the piece's current position
      next_row = current_row + row_offset
      next_col = current_col + col_offset

      # Keep moving in one direction until you hit the edge or another piece
      while board.on_board?([next_row, next_col])
        destination_square = board.piece_at([next_row, next_col])

        if destination_square.nil?
          # If the square is empty, it's a valid move. Keep going.
          possible_moves << [next_row, next_col]
        elsif destination_square.color != self.color
          # If it's an enemy piece, it's a valid capture. Stop exploring in this direction.
          possible_moves << [next_row, next_col]
          break
        else
          # If it's a friendly piece, you can't move there. Stop exploring.
          break
        end

        # Move one more step in the current direction
        next_row += row_offset
        next_col += col_offset
      end
    end

    possible_moves
  end

  def to_s
    color == :white ? '♜' : '♖'
  end
end
