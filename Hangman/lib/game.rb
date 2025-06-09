require 'json'
require_relative 'dictionary'
require_relative 'display'

class Game
  include Display
  MAX_INCORECT_GUESSES = 6

  attr_accessor :secret_word, :correct_letters, :incorrect_letters, :remaining_guesses

  def initialize
    dictionary = Dictionary.new('words/')
