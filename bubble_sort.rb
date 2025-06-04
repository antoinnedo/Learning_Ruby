# frozen_string_literal: true

def bubble_sort(array)
  swapped = true
  (array.length-1).times do |i|
    break if swapped == false
    swapped = false
      (0..array.length - i - 2).each do |j|
        if array[j] > array[j + 1]
          array[j], array[j + 1] = array[j + 1], array[j]
          swapped = true
        end
      end
    end
  end
  puts array
end

bubble_sort([4,3,78,2,0,2])
