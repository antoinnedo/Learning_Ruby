# spec/pieces/queen_spec.rb
require 'spec_helper'

describe Queen do
  let(:board) { Board.new }

  describe '#moves' do
    context 'in the middle of an empty board' do
      let(:queen) { Queen.new(:white, [3, 3]) } # Place queen at d5

      before do
        # Clear the board to test movement without obstruction
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = queen
      end

      it 'can move in all 8 directions (horizontal, vertical, and diagonal)' do
        # Instead of listing every square, we can check the total number
        # of moves and then sample one move from each of the 8 directions
        # to ensure all vectors are covered. A queen from the center
        # of an empty board should have 27 possible moves.
        moves = queen.moves(board)

        expect(moves.count).to eq(27)
        expect(moves).to include(
          [3, 0], # Left
          [3, 7], # Right
          [0, 3], # Up
          [7, 3], # Down
          [0, 0], # Diagonal Up-Left
          [6, 0], # Diagonal Down-Left
          [1, 5], # Diagonal Up-Right
          [5, 5]  # Diagonal Down-Right
        )
      end
    end

    context 'on a standard starting board' do
      it 'has no legal moves because it is blocked' do
        queen = board.piece_at([7, 3]) # White queen at d1
        expect(queen.moves(board)).to be_empty
      end
    end

    context 'when blocked by friendly and enemy pieces' do
      let(:queen) { Queen.new(:white, [3, 3]) }

      before do
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = queen
        # Friendly piece (cannot move to or past)
        board.grid[1][3] = Pawn.new(:white, [1, 3])
        # Enemy piece (can move to, but not past)
        board.grid[5][5] = Pawn.new(:black, [5, 5])
      end

      it 'is blocked by friendly pieces' do
        # Cannot move to [1,3] or past it to [0,3]
        expect(queen.moves(board)).to_not include([1, 3], [0, 3])
      end

      it 'can capture an enemy piece' do
        # Can move to the enemy pawn's square
        expect(queen.moves(board)).to include([5, 5])
      end

      it 'is blocked by the captured enemy piece' do
        # Cannot move past the captured pawn
        expect(queen.moves(board)).to_not include([6, 6])
      end

      it 'can still move freely in unblocked directions' do
        # Should still be able to move freely to the left
        expect(queen.moves(board)).to include([3, 2], [3, 1], [3, 0])
      end
    end
  end
end
