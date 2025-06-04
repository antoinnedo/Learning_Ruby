# frozen_string_literal: true

# Implement a Caesar cipher that takes in a string and the shift factor
# and then outputs the modified string using a right shift:
# create a new string first then edit in_place

# def caesar_cipher_new_msg(og_msg, char_shift)
#   encrypted_msg = ""
#   og_msg.each_char do |character|
#     if character.match(/[a-z]/)
#       new_ascii = (((character.ord + char_shift - 'a'.ord) %2 6) + 'a'.ord)
#       encrypted_msg += new_ascii.chr
#     elsif character.match(/[A-Z]/)
#       new_ascii = ((character.ord + char_shift - 'A'.ord) % 26) + 'A'.ord
#       encrypted_msg += new_ascii.chr
#     else
#       encrypted_msg += character
#     end
#   end
#   puts encrypted_msg
# end

def caesar_cipher(msg, char_shift)
  msg.each_char.with_index do |character, index|
    # deciding starting code to add
    base = determine_base_ascii(character)

    # eg: for z,2: z->122+2-97=>27%26 = 1 => shift z to b
    new_ascii = (((character.ord + char_shift - base) % 26) + base)
    msg[index] = new_ascii.chr
  end
  msg
end

private

def determine_base_ascii(character)
  if character.match?(/[a-z]/)
    'a'.ord
  elsif character.match?(/[A-Z]/)
    'A'.ord
  end
end

puts caesar_cipher('hahaha', 5)
