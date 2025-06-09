class Dictionary
  def initialize(file_path)
    @words = File.readlines(file_path, chomp: true)
      .select { |words| words.length.between?(5, 12)}
  end

  def random_word
    @words.sample.downcase
  end
end
