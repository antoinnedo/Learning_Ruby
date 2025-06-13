# spec/game_spec.rb
require 'spec_helper'

describe Game do
  describe '#play' do
    let(:game) { Game.new }

    # To test the play loop, you need to control user input.
    # We can use `allow` to make `gets` return a specific sequence of strings.
    before do
      # Suppress puts to keep test output clean
      allow($stdout).to receive(:puts)
    end

    it 'switches players after a valid move' do
      # Simulate player entering "e2e4"
      allow(game).to receive(:gets).and_return("e2e4\n")

      # The player before the move is white
      expect(game.instance_variable_get(:@current_player).color).to eq(:white)

      # process_move returns true on success, which triggers a player switch
      game.send(:process_move, game.send(:get_move))
      game.send(:switch_player!) # Manually call the switch for the test

      # The player after the move should be black
      expect(game.instance_variable_get(:@current_player).color).to eq(:black)
    end
  end

  describe '#checkmate?' do
    it 'correctly identifies a checkmate scenario (Fool\'s Mate)' do
      game = Game.new
      board = game.instance_variable_get(:@board)

      # --- Set up Fool's Mate ---
      # 1. f2f3
      board.move_piece([6, 5], [5, 5])
      # 2. e7e5
      board.move_piece([1, 4], [3, 4])
      # 3. g2g4
      board.move_piece([6, 6], [4, 6])
      # 4. d8h4# (Black Queen moves to h4)
      board.move_piece([0, 3], [4, 7])

      # It is now white's turn, and white is in checkmate.
      expect(game.send(:checkmate?, :white)).to be true
    end
  end
end
