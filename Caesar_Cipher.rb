=begin
Implement a Caesar cipher that takes in a string and the shift factor and then outputs the modified string using a right shift:
create a new string first then edit in_place
=end

# def caesar_cipher_new_msg(og_msg, char_shift)
#   encrypted_msg = ""
#   og_msg.each_char do |character|
#     if character.match(/[a-z]/)
#       new_ascii = (((character.ord + char_shift - 'a'.ord)%26) + 'a'.ord)
#       encrypted_msg += new_ascii.chr
#     elsif character.match(/[A-Z]/)
#       new_ascii = ((character.ord + char_shift - 'A'.ord)%26) + 'A'.ord
#       encrypted_msg += new_ascii.chr
#     else
#       encrypted_msg += character
#     end
#   end
#   puts encrypted_msg
# end

def caesar_cipher(og_msg, char_shift)
  og_msg.each_char.with_index do |character, index|
    if character.match(/[a-z]/)
      new_ascii = (((character.ord + char_shift - 'a'.ord)%26) + 'a'.ord) # eg: for z,2: z->122+2-97=>27%26 = 1 => shift z to b
      og_msg[index] = new_ascii.chr
    elsif character.match(/[A-Z]/)
      new_ascii = ((character.ord + char_shift - 'A'.ord)%26) + 'A'.ord
      og_msg[index] = new_ascii.chr
    end
  end
end

puts caesar_cipher("hahaha", 5)
