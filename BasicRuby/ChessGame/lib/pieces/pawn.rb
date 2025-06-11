# ChessGame/lib/pieces/pawn.rb

require_relative '../piece'

class Pawn < Piece
  # The `moves` method calculates all legal moves for a pawn from its
  # current position, given the current state of the board.
  def moves(board)
    possible_moves = []

    # The list of moves is a combination of standard forward moves
    # and potential diagonal captures.
    possible_moves.concat(forward_moves(board))
    possible_moves.concat(capture_moves(board))

    possible_moves
  end

  def to_s
    color == :white ? '♟︎' : '♙'
  end

  private

  # Determines the direction of pawn movement. White moves "up" (row index decreases),
  # black moves "down" (row index increases).
  def forward_direction
    color == :white ? -1 : 1
  end

  # Checks if the pawn is in its starting row.
  def at_start_row?
    start_row = (color == :white) ? 6 : 1
    position[0] == start_row
  end

  # Calculates the one-step and potential two-step forward moves.
  def forward_moves(board)
    moves = []
    current_row, current_col = position

    # 1. Standard one-square move
    one_step_forward = [current_row + forward_direction, current_col]
    if board.on_board?(one_step_forward) && board.piece_at(one_step_forward).nil?
      moves << one_step_forward

      # 2. Initial two-square move
      # This can only happen if the one-step move is also possible.
      two_steps_forward = [current_row + 2 * forward_direction, current_col]
      if at_start_row? && board.piece_at(two_steps_forward).nil?
        moves << two_steps_forward
      end
    end

    moves
  end

  # Calculates the diagonal capture moves.
  def capture_moves(board)
    moves = []
    current_row, current_col = position

    # The two potential diagonal capture positions
    capture_positions = [
      [current_row + forward_direction, current_col - 1], # Diagonal left
      [current_row + forward_direction, current_col + 1]  # Diagonal right
    ]

    capture_positions.each do |pos|
      # A capture is only valid if the destination is on the board
      # and occupied by an enemy piece.
      next unless board.on_board?(pos)

      destination_piece = board.piece_at(pos)
      if destination_piece && destination_piece.color != self.color
        moves << pos
      end
    end

    moves
  end
end
