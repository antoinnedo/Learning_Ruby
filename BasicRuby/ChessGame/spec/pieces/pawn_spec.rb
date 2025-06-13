# spec/pieces/pawn_spec.rb
require 'spec_helper'

describe Pawn do
  let(:board) { Board.new } # Use a fresh board for each test block

  describe '#moves' do
    context "for a white pawn at its starting position" do
      let(:pawn) { board.piece_at([6, 4]) } # White pawn at e2

      it 'can move one or two steps forward' do
        expect(pawn.moves(board)).to include([5, 4], [4, 4])
      end

      it 'cannot move two steps forward if blocked' do
        # Place a piece in front of the pawn
        board.grid[5][4] = Piece.new(:black, [5, 4])
        expect(pawn.moves(board)).to_not include([4, 4])
      end
    end

    context 'for a black pawn with capture opportunities' do
      let(:pawn) { board.piece_at([1, 3]) } # Black pawn at d7

      before do
        # Place white pieces diagonally in front of the black pawn
        board.grid[2][2] = Piece.new(:white, [2, 2]) # at c6
        board.grid[2][4] = Piece.new(:white, [2, 4]) # at e6
      end

      it 'includes diagonal capture moves' do
        expect(pawn.moves(board)).to include([2, 2], [2, 4])
      end

      it 'does not include a capture move on an empty square' do
        board.grid[2][2] = nil # Remove the piece at c6
        expect(pawn.moves(board)).to_not include([2, 2])
      end
    end
  end

  context 'for en passant' do
    # Setup: A white pawn on e5, which is the correct rank to perform en passant.
    let(:white_pawn) { Pawn.new(:white, [3, 4]) } # White pawn at e5

    before do
      # Clear the board and place our white pawn.
      board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
      board.grid[3][4] = white_pawn

      # For this test, we manually set the state. We simulate that a
      # black pawn on an adjacent file (d-file) just moved from d7 to d5.
      board.en_passant_vulnerable = [3, 3] # Position of the vulnerable black pawn at d5
    end

    it 'includes the en passant capture as a possible move' do
      # The white pawn at e5 ([3, 4]) should be able to capture the black pawn at d5 ([3, 3])
      # by moving diagonally to the square behind it, which is d6 ([2, 3]).
      en_passant_move = [2, 3]
      expect(white_pawn.moves(board)).to include(en_passant_move)
    end

    it 'does not allow en passant if a turn has passed' do
      # The en passant move is only available on the very next turn.
      # The Game class should clear the vulnerable state after each move.
      # We simulate this by setting it to nil.
      board.en_passant_vulnerable = nil

      en_passant_move = [2, 3]
      expect(white_pawn.moves(board)).to_not include(en_passant_move)
    end

    it 'does not allow en passant for a non-adjacent pawn' do
      # If the vulnerable pawn was on the c-file instead of the d-file.
      board.en_passant_vulnerable = [3, 2] # Vulnerable pawn at c5
      en_passant_move = [2, 3]
      expect(white_pawn.moves(board)).to_not include(en_passant_move)
    end
  end
end
