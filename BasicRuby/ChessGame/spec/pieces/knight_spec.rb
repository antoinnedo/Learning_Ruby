# spec/pieces/knight_spec.rb
require 'spec_helper'

describe Knight do
  describe '#moves' do
    let(:board) { Board.new } # A board is needed for context

    context 'when in the middle of the board' do
      it 'returns all 8 possible L-shaped moves' do
        knight = Knight.new(:white, [4, 4])
        # From [4, 4], a knight should be able to reach 8 squares
        expected_moves = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]

        # The #moves method should return an array containing exactly these moves
        expect(knight.moves(board)).to match_array(expected_moves)
      end
    end

    context 'when near a corner' do
      it 'returns only the 2 moves that stay on the board' do
        knight = Knight.new(:black, [0, 1])
        expected_moves = [[1, 3], [2, 2], [2, 0]] # Adjusted for being near the top
        # Note: Your current knight#moves doesn't check for friendly pieces,
        # so this test assumes it just checks for board boundaries.
        expect(knight.moves(board)).to match_array(expected_moves)
      end
    end
  end
end
