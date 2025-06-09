require 'json'
require_relative 'dictionary'
require_relative 'display'


class Game
  include Display
  MAX_INCORECT_GUESSES = 6

  attr_accessor :secret_word, :incorrect_letters
  attr_accessor :correct_letters, :remaining_guesses

  def initialize
    # byebug
    dictionary_path = File.expand_path('../words/google-10000-english-no-swears.txt', __dir__)
    @dictionary = Dictionary.new(dictionary_path)
    @remaining_guesses = MAX_INCORECT_GUESSES
    @correct_letters = []
    @incorrect_letters = []
    @secret_word = @dictionary.random_word #get a word in the dictionary
  end

  # main game loop
  def play
    until game_over?
      display_status(@secret_word, @correct_letters, @incorrect_letters, @remaining_guesses)
      process_turn
    end
    display_result
  end

  #handle the player's guesses
  def process_turn()
    player_input = get_guess
    case player_input
    when :save
      save_game
      puts "Game saved! You can keep playing."
    when :exit
      puts "Exiting game. Your progress will be lost!"
      exit(0)
    else
      check_guess(player_input)
    end
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    print "Enter a name for your save file: "
    save_name = gets.chomp
    filename = "saves/hangman_#{save_name}.json"

    File.write(filename, to_json)
    puts "Game saved as #{save_name}.json!"

    if File.exist?(filename)
      print "Save file already exists. Overwrite? (y/n):"
      overwrite = gets.chomp.downcase
      if overwrite == 'y'
        puts "Overwrote save file."
        return
      end
    end

    File.write(filename, to_json)
    puts "Game saved as #{save_name}.json!"

    print "Do you want to exit? (y/n): "
    exit_choice = gets.chomp.downcase
    if exit_choice == 'y'
        puts "Exiting game."
        exit(0)
    end
  end

  def self.load_game(filename)
    data = JSON.parse(File.read(filename))
    game = new
    game.secret_word = data['secret_word']
    game.incorrect_letters = data['incorrect_letters']
    game.correct_letters = data['correct_letters']
    game.remaining_guesses = data['remaining_guesses']
    game
  end

  # serialize game save to json
  def to_json(*_args)
    JSON.dump({
      secret_word: @secret_word,
      incorrect_letters: @incorrect_letters,
      correct_letters: @correct_letters,
      remaining_guesses: @remaining_guesses
    })
  end


  # Validates player guess meets requirements
  # @param input [String] Player's input
  # @return [Boolean] True if valid letter guess
  def valid_letter?(input)
    input.length == 1 && # Single character
      input =~ /[a-z]/ && # Letter a-z
      !(@correct_letters + @incorrect_letters).include?(input) # Not already guessed
  end

  # Processes letter guess and updates game state
  # @param letter [String] The guessed letter
  def check_guess(letter)
    if @secret_word.include?(letter)
      @correct_letters << letter # Add to correct guesses
    else
      @incorrect_letters << letter # Add to incorrect guesses
      @remaining_guesses -= 1 # Decrement remaining attempts
    end
  end

  #take player's input
  def get_guess
    loop do
      print "Enter a letter or \'!save\' or '\!exit\' to save game:"
      input = gets.chomp.downcase

      case input
      when '!save' then return :save
      when '!exit' then return :exit
      else
        return input if valid_letter?(input)
        puts "Invalid input. Please enter a letter (a-z) or command (!save/!exit)"
      end
    end
  end

  def game_over?
    @remaining_guesses.zero? || won?
  end

  def won?
    (@secret_word.chars.uniq - @correct_letters).empty? #an array - an array => #empty?
  end

  def display_result
    if won?
      puts "Lmao good shi bro. Ya won! The word is #{@secret_word}"
    else
      puts "Lmao ya stink. Big L. The word is #{@secret_word}"
    end
  end
end
