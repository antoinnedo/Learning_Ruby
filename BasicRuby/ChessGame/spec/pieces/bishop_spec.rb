# spec/pieces/bishop_spec.rb
require 'spec_helper'

describe Bishop do
  let(:board) { Board.new }

  describe '#moves' do
    context 'in the middle of an empty board' do
      let(:bishop) { Bishop.new(:white, [3, 3]) } # Place bishop at d5

      before do
        # Clear the board to test movement without obstruction
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = bishop
      end

      it 'can move diagonally in all 4 directions' do
        # A bishop in the center of an empty board should have 13 possible moves.
        moves = bishop.moves(board)

        expect(moves.count).to eq(13)

        # Check that the moves include the furthest square in each diagonal direction
        expect(moves).to include(
          [0, 0], # Up-Left
          [7, 7], # Down-Right
          [0, 6], # Up-Right
          [6, 0]  # Down-Left
        )
      end
    end

    context 'on a standard starting board' do
      it 'has no legal moves because it is blocked' do
        bishop = board.piece_at([7, 2]) # White bishop at c1
        expect(bishop.moves(board)).to be_empty
      end
    end

    context 'when blocked by friendly and enemy pieces' do
      let(:bishop) { Bishop.new(:white, [3, 3]) }

      before do
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = bishop
        # Friendly piece (cannot move to or past)
        board.grid[1][1] = Pawn.new(:white, [1, 1])
        # Enemy piece (can move to, but not past)
        board.grid[5][5] = Pawn.new(:black, [5, 5])
      end

      it 'is blocked by friendly pieces' do
        # Cannot move to [1,1] or past it to [0,0]
        expect(bishop.moves(board)).to_not include([1, 1], [0, 0])
      end

      it 'can capture an enemy piece' do
        # Can move to the enemy pawn's square
        expect(bishop.moves(board)).to include([5, 5])
      end

      it 'is blocked by the captured enemy piece' do
        # Cannot move past the captured pawn
        expect(bishop.moves(board)).to_not include([6, 6])
      end

      it 'can still move freely in unblocked directions' do
        # Should still be able to move freely up and to the right
        expect(bishop.moves(board)).to include([2, 4], [1, 5], [0, 6])
      end
    end
  end
end

