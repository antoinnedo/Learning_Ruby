class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end
end


class LinkedList
  def initialize
    @size = 0
    @head = nil
    @tail = nil
  end

  def append(value)
    new_node = Node.new(value)
    if @size == 0
      @head = @tail = new_node
    else
      @tail.next_node = new_node
      @tail = new_node
    end
    @size += 1
  end

  def prepend(value)
    new_node = Node.new(value)
    if @size == 0
      @head = @tail = new_node
    else
      new_node.next_node = @head
      @head = new_node
    end
    @size += 1
  end

  def head
    @head
  end

  def tail
    @tail
  end

  def size
    @size
  end

  def at(index)
    return nil if index >= @size || index < 0

    current = @head
    index.times { current = current.next_node }
    current.value
  end

  def pop
    return nil if @size == 0

    if @size == 1
      value = @head.value
      @head = @tail = nil
      @size = 0
      return value
    end

    current = @head
    current = current.next_node until current.next_node.next_node.nil?
    value = current.next_node.value
    current.next_node = nil
    @tail = current
    @size -= 1
    value
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value
      current = current.next_node
    end
    false
  end

  def find(value)
    current = @head
    until current.nil?
      return value if current.value == value
      current = current.next_node
    end
  end

  def to_s
    return "List is empty" if @size == 0

    current = @head
    str = ""
    while current
      str += "( #{current.value} )"
      str += " -> " unless current.next_node.nil?
      current = current.next_node
    end
    str
  end
end
