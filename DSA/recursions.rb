# fib: takes in int a, make an fibonacci array that has 8 elements

def fibonacci(size)
  if size <= 1
    size
  else
    fibonacci(size - 1) + fibonacci(size - 2)
  end
end

# puts fibonacci(10)

def merge_sort(arr)
  return arr if arr.size <= 1

  mid = arr.size / 2

  left_arr = merge_sort(arr[0...mid])
  right_arr = merge_sort(arr[mid..])

  sorted_arr = Array.new(left_arr.size + right_arr.size)
  merge(sorted_arr, left_arr, right_arr)
  p sorted_arr
end

def merge(sorted_arr, left_arr, right_arr)
  i = j = k = 0

  while j < left_arr.size && k < right_arr.size
    if left_arr[j] <= right_arr[k]
      sorted_arr[i] = left_arr[j]
      j += 1
    else
      sorted_arr[i] = right_arr[k]
      k += 1
    end
    i += 1
  end

  while j < left_arr.size
    sorted_arr[i] = left_arr[j]
    i += 1
    j += 1
  end

  while k < right_arr.size
    sorted_arr[i] = right_arr[k]
    i += 1
    k += 1
  end
end

array = [38, 27, 43, 3, 9, 82, 10]
sorted_array = merge_sort(array)
puts sorted_array #=> [3, 9, 10, 27, 38, 43, 82]
