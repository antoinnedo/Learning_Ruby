class HashMap
  attr_accessor :load, :capacity, :size

  def initialize(initial_capacity = 16, load_factor = 0.75)
    # Initialize instance variables
    @capacity = initial_capacity  # Current number of buckets
    @load_factor = load_factor    # Threshold for resizing
    @buckets = Array.new(@capacity) { [] }  # Array of buckets (each is an array)
    @size = 0                    # Number of key-value pairs stored
  end

  # Generates a hash code for the key (compressed to bucket size)
  def hash(key)
    hash_code = 0
    prime_number = 31

    # Polynomial rolling hash function
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    # Ensure positive index within bucket range
    hash_code % @capacity
  end

  # Inserts or updates a key-value pair
  def set(key, value)
    grow_buckets if needs_resizing?  # Check if we need to resize first

    index = hash(key)
    bucket = @buckets[index]

    # Check if key already exists
    pair = bucket.find { |k, _| k == key }

    if pair
      pair[1] = value  # Update existing value
    else
      bucket << [key, value]  # Add new entry
      @size += 1
    end
  end

  # Retrieves value for a key (returns nil if not found)
  def get(key)
    index = hash(key)
    bucket = @buckets[index]

    # Find and return the value
    pair = bucket.find { |k, _| k == key }
    pair&.last
  end

  # Checks if key exists in the map
  def has?(key)
    index = hash(key)
    @buckets[index].any? { |k, _| k == key }
  end

  # Removes a key-value pair and returns the value
  def remove(key)
    index = hash(key)
    bucket = @buckets[index]

    # Find and remove the pair
    pair_index = bucket.index { |k, _| k == key }
    return nil unless pair_index

    removed = bucket.delete_at(pair_index)
    @size -= 1
    removed.last
  end

  # Current number of stored key-value pairs
  def length
    @size
  end

  # Resets the hash map to initial state
  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  # Returns array of all keys
  def keys
    @buckets.flat_map { |bucket| bucket.map(&:first) }
  end

  # Returns array of all values
  def values
    @buckets.flat_map { |bucket| bucket.map(&:last) }
  end

  # Returns array of all [key, value] pairs
  def entries
    @buckets.flat_map { |bucket| bucket.map(&:itself) }
  end

  private

  # Checks if we've exceeded the load factor
  def needs_resizing?
    @size.to_f / @capacity >= @load_factor
  end

  # Doubles capacity and rehashes all entries
  def grow_buckets
    old_buckets = @buckets
    @capacity *= 2               # Double the capacity
    @buckets = Array.new(@capacity) { [] }
    @size = 0                    # Reset size (will be rebuilt during rehashing)

    # Reinsert all existing entries
    old_buckets.each do |bucket|
      bucket.each { |key, value| set(key, value) }
    end
  end
end

# Create with custom capacity and load factor
map = HashMap.new(8, 0.6)  # Smaller initial capacity, lower load factor

# Test basic operations
map.set("name", "Alice")
puts map.get("name")        # => "Alice"
puts map.has?("name")       # => true
puts map.length            # => 1

# Test collision handling
map.set("abc", "first")    # These might collide depending on hash function
map.set("cba", "second")   # but will be stored in same bucket

# Test resizing
10.times { |i| map.set("key#{i}", i) }  # Force resize
puts map.capacity          # Should be doubled (16)
