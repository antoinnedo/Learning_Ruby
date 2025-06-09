#!/usr/bin/env ruby
require_relative '../lib/game'
require 'byebug'

# Displays main menu and handles user selection
def main_menu
  puts "HANGMAN"
  puts "1. New Game"
  puts "2. Load Game"
  print "Select option: "
  choice = gets.chomp

  case choice
  when '1'
    Game.new.play # Start new game
  when '2'
    load_game # Load saved game
  else
    puts "Invalid choice"
    main_menu # Show menu again on invalid input
  end
end

# Handles saved game selection and loading
def load_game
  saves = Dir.glob('saves/*.json')
  if saves.empty?
    puts "No saved games found."
    main_menu
    return
  end

  puts "Saved Games:"
  saves.each_with_index { |file, i| puts "#{i + 1}. #{File.basename(file, '.json')}" }
  print "Select a game to load (or enter '0' to go back): "
  choice = gets.chomp.to_i

  if choice.zero?
    main_menu
  elsif choice.between?(1, saves.size)
    game = Game.load_game(saves[choice - 1])
    game.play if game
  else
    puts "Invalid selection."
    load_game
  end
end

# Start the game
main_menu
