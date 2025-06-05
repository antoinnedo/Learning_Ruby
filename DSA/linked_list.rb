class Node
  attr_accessor :value, :next

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
    new_node = Node.new()
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
    current = @head
    count = 0
    while current and count < index
      current = current.next_node
      count += 1
    end
    current.value
  end

  def pop
    return nil if @head.nil?

    if @head.next.nil?
      value = @head.value
      @head = @tail = nil
      return value
    end

    current = @head
    current = current.next until current.next.next.nil?
    value = current.next.value
    current.next = nil
    @tail = current
    return value
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value
      current = current.next_node
    end
    false
  end

  def
