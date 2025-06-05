# antoinnedo/learning_ruby/Learning_Ruby-main/Mastermind/colors.rb
class Colors
  VALID_COLORS = ['BLUE', 'RED', 'GREEN', 'YELLOW', 'VIOLET', 'BLACK', 'WHITE'].freeze
  CODE_LENGTH = 4 # Or any other length you prefer
  MAX_TURNS = 10   # Or any other number of turns

  def self.sample_code
    Array.new(CODE_LENGTH) { VALID_COLORS.sample }
  end
end
