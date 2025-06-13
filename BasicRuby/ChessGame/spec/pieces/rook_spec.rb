# spec/pieces/rook_spec.rb
require 'spec_helper'

describe Rook do
  let(:board) { Board.new }

  describe '#moves' do
    context 'in the middle of an empty board' do
      let(:rook) { Rook.new(:white, [3, 3]) } # Place rook at d5

      before do
        # Clear the board to test movement without obstruction
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = rook
      end

      it 'can move horizontally and vertically' do
        # A rook in the center of an empty board should have 14 possible moves.
        moves = rook.moves(board)

        expect(moves.count).to eq(14)

        # Check that the moves include the furthest square in each direction
        expect(moves).to include(
          [3, 0], # Left
          [3, 7], # Right
          [0, 3], # Up
          [7, 3]  # Down
        )
      end
    end

    context 'on a standard starting board' do
      it 'has no legal moves because it is blocked' do
        rook = board.piece_at([7, 0]) # White rook at a1
        expect(rook.moves(board)).to be_empty
      end
    end

    context 'when blocked by friendly and enemy pieces' do
      let(:rook) { Rook.new(:white, [3, 3]) }

      before do
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = rook
        # Friendly piece (cannot move to or past)
        board.grid[3][1] = Pawn.new(:white, [3, 1])
        # Enemy piece (can move to, but not past)
        board.grid[5][3] = Pawn.new(:black, [5, 3])
      end

      it 'is blocked by friendly pieces' do
        # Cannot move to [3,1] or past it to [3,0]
        expect(rook.moves(board)).to_not include([3, 1], [3, 0])
      end

      it 'can capture an enemy piece' do
        # Can move to the enemy pawn's square
        expect(rook.moves(board)).to include([5, 3])
      end

      it 'is blocked by the captured enemy piece' do
        # Cannot move past the captured pawn
        expect(rook.moves(board)).to_not include([6, 3])
      end

      it 'can still move freely in unblocked directions' do
        # Should still be able to move freely to the right
        expect(rook.moves(board)).to include([3, 4], [3, 5], [3, 6], [3, 7])
      end
    end
  end
end

