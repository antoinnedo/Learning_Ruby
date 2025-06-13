# ChessGame/lib/pieces/king.rb

require_relative '../piece'

class King < Piece
  # The King can move one square in any of the 8 directions.
  MOVE_DIRECTIONS = [
    [0, 1], [0, -1], [1, 0], [-1, 0],  # Straight
    [1, 1], [1, -1], [-1, 1], [-1, -1] # Diagonal
  ]

  def moves(board)
    possible_moves = []
    current_row, current_col = position

    # --- Standard King Moves ---
    MOVE_DIRECTIONS.each do |row_offset, col_offset|
      new_row = current_row + row_offset
      new_col = current_col + col_offset
      new_pos = [new_row, new_col]

      next unless board.on_board?(new_pos)

      destination_square = board.piece_at(new_pos)
      if destination_square.nil? || destination_square.color != self.color
        possible_moves << new_pos
      end
    end

    # # --- Add Castling Moves ---
    # add_castling_moves(board, possible_moves)
    # WE DONT DO DIS NO MO

    possible_moves
  end

  # This method checks for and adds valid castling moves to the king's move list.
  def add_castling_moves(board, moves)
    # 1. The king must not have moved yet.
    # 2. The king cannot be in check.
    return if self.has_moved
    return if board.in_check?(self.color)

    king_row = self.position[0]
    opponent_color = (self.color == :white) ? :black : :white

    # Helper lambda to check if a specific square is under attack by the opponent.
    is_attacked = ->(pos) do
      board.pieces(opponent_color).any? do |piece|
        # We use the basic `moves` method here, not `valid_moves`, to avoid infinite loops.
        piece.moves(board).include?(pos)
      end
    end

    # --- Check Kingside Castling (O-O) ---
    kingside_rook = board.piece_at([king_row, 7])
    if kingside_rook.is_a?(Rook) && !kingside_rook.has_moved
      # Path between king and rook must be empty.
      path_empty = board.piece_at([king_row, 5]).nil? && board.piece_at([king_row, 6]).nil?
      if path_empty
        # King cannot pass through a square that is under attack.
        # The final square ([king_row, 6]) is checked by the `valid_moves` method automatically.
        path_safe = !is_attacked.call([king_row, 5])
        moves << [king_row, 6] if path_safe
      end
    end

    # --- Check Queenside Castling (O-O-O) ---
    queenside_rook = board.piece_at([king_row, 0])
    if queenside_rook.is_a?(Rook) && !queenside_rook.has_moved
      # Path between king and rook must be empty.
      path_empty = board.piece_at([king_row, 1]).nil? && board.piece_at([king_row, 2]).nil? && board.piece_at([king_row, 3]).nil?
      if path_empty
        # King cannot pass through a square that is under attack.
        # The final square ([king_row, 2]) is checked by `valid_moves`.
        path_safe = !is_attacked.call([king_row, 3])
        moves << [king_row, 2] if path_safe
      end
    end
  end

  def to_s
    color == :white ? '♚' : '♔'
  end
end
