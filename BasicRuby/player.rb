# lib/player.rb

# The Player class represents one of the two players in the game.
# Its primary responsibility is to store the player's color.
class Player
  # We use attr_reader to allow other objects (like the Game class)
  # to read the player's color, but not change it.
  attr_reader :color

  # When a new player is created, they must be assigned a color.
  def initialize(color)
    @color = color
  end
end
