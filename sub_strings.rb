#takes in string and array
#check all the word in the string is a substring of any element in the array

#idea:
#include? : used to check the array
# Hash.new?

def substrings_single(string, dictionary)
  hashmap = Hash.new(0)

  dictionary.each do |word|
      if string.include?(word)
      #?:
        hashmap[word] += 1
      end
  end
  puts hashmap
end

def substrings_sentence(bigstring, dictionary)
  string_array = bigstring.downcase.split(/[^a-zA-Z]/) #=>make an array
  hashmap = Hash.new(0)

  string_array.each do |string|
    dictionary.each do |word|
        if string.include?(word)
          hashmap[word] += 1
        end
    end
  end

  puts hashmap
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

substrings_single("below", dictionary)
substrings_sentence("Howdy partner, sit down! How's it going?", dictionary)
