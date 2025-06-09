module Display
  def display_gallows(incorrect_guesses)
    stages = [
      """
        -----
        |   |
            |
            |
            |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
            |
            |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
       /    |
            |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
       /|   |
            |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
       /|\  |
            |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
       /|\  |
       /    |
            |
      ---------
      """,
      """
        -----
        |   |
        O   |
       /|\  |
       / \  |
            |
      ---------
      """
    ]
    puts stages[[incorrect_guesses, stages.size - 1].min]
  end

  def display_word(secret_word, correct_letters)
    secret_word.chars.map { |c| correct_letters.include?(c) ? '\u2714' : '_' }.join(' ')
  end

  def display_status(secret_word, correct_letters, incorrect_letters, remaining_guesses)
    display_gallows(incorrect_letters.size)
    puts "Word: #{display_word(secret_word, correct_letters)}"
    puts "Incorrect guesses: #{incorrect_letters.join(', ')}"
    puts "Guesses remaining: #{remaining_guesses}"
  end
end
