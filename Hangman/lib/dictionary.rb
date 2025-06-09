class Dictionary
  def initialize(file_path)
    @words = File.readlines(file_path, chomp: true)
      .select { |word| word.length.between?(5, 12)}
  end

  def ramdom_word
    @word.sample.downcase
  end
end
