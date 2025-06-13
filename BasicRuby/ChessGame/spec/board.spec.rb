# spec/board_spec.rb
require 'spec_helper'

describe Board do
  describe '#initialize' do
    it 'sets up the board with 32 pieces' do
      board = Board.new
      # Flatten the grid, remove nils, and count the pieces
      piece_count = board.grid.flatten.compact.size
      expect(piece_count).to eq(32)
    end

    it 'places the white king in the correct starting position' do
      board = Board.new
      king = board.piece_at([7, 4])
      expect(king).to be_a(King)
      expect(king.color).to eq(:white)
    end
  end

  describe '#move_piece' do
    it 'correctly moves a piece from a start to an end position' do
      board = Board.new
      start_pos = [6, 4] # e2
      end_pos = [4, 4]   # e4

      pawn = board.piece_at(start_pos)
      board.move_piece(start_pos, end_pos)

      # Check that the piece is now at the end position
      expect(board.piece_at(end_pos)).to eq(pawn)
      # Check that the starting position is now empty
      expect(board.piece_at(start_pos)).to be_nil
    end
  end

  describe '#in_check?' do
    it 'returns true when a king is under attack' do
      board = Board.new
      # Create a custom board setup for the test
      board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) }) # Clear board

      # Place a white king at e1 and a black rook at e8
      board.grid[7][4] = King.new(:white, [7, 4])
      board.grid[0][4] = Rook.new(:black, [0, 4])

      expect(board.in_check?(:white)).to be true
    end

    it 'returns false when a king is not under attack' do
      board = Board.new
      expect(board.in_check?(:white)).to be false
      expect(board.in_check?(:black)).to be false
    end
  end
end
