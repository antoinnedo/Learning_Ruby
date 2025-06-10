# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/colors.rb
class Colors
  VALID_COLORS = ['BLUE', 'RED', 'GREEN', 'YELLOW', 'VIOLET', 'ORANGE', 'CYAN', 'MAGENTA'].freeze

  # Note: MAX_TURNS is removed from here.

  def self.generate_secret_code(code_length)
    Array.new(code_length) { VALID_COLORS.sample }
  end
end
