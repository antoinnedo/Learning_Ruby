# spec/pieces/king_spec.rb
require 'spec_helper'

describe King do
  let(:board) { Board.new }

  describe '#moves' do
    context 'on a standard starting board' do
      let(:king) { board.piece_at([7, 4]) } # White king at e1

      it 'has no legal moves because it is blocked by friendly pieces' do
        expect(king.moves(board)).to be_empty
      end
    end

    context 'when its starting adjacent squares are clear' do
      # We define king inside the 'it' block now.
      # let(:king) { board.piece_at([7, 4]) } # We are moving this line.

      before do
        # This setup block runs before the test. We manually clear the
        # 5 squares around the king.
        board.grid[6][3] = nil # d2 pawn
        board.grid[6][4] = nil # e2 pawn
        board.grid[6][5] = nil # f2 pawn
        board.grid[7][3] = nil # d1 queen
        board.grid[7][5] = nil # f1 bishop
      end

      it 'can move to the 5 surrounding squares' do
        # This is the test case you described.
        expected_moves = [
          [6, 3], # forward-left
          [6, 4], # forward
          [6, 5], # forward-right
          [7, 3], # left
          [7, 5]  # right
        ]

        # FIX: Get the king *after* the board has been modified by the 'before' block.
        king = board.piece_at([7, 4])

        expect(king.moves(board)).to match_array(expected_moves)
      end
    end

    context 'in the middle of an empty board' do
      let(:king) { King.new(:white, [3, 3]) } # Place king at d5

      before do
        board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        board.grid[3][3] = king
      end

      it 'can move to all 8 surrounding squares' do
        expected_moves = [
          [2, 2], [2, 3], [2, 4],
          [3, 2],         [3, 4],
          [4, 2], [4, 3], [4, 4]
        ]
        expect(king.moves(board)).to match_array(expected_moves)
      end
    end
  end
end
