class Node
  attr_reader :position, :parent # keeping track of value aka position and parent

  def initialize(position, parent = nil)
    @position = position
    @parent = parent
  end
end

class Knight
  # Possible moves
  MOVES = [
    [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2]
  ].freeze

  def knight_moves(start_pos, end_pos)
    return [start_pos] if start_pos == end_pos

    queue = [Node.new(start_pos)]

    visited = { start_pos => true } #keep track of visited squares

    until queue.empty?
      current_node = queue.shift

      if current_node.position == end_pos
        return reconstruct_path(current_node)
      end

      each_valid_move(current_node.position) do |next_pos|
        unless visited.key?(next_pos)

        visited[next_pos] = true #mark as visited

        new_node = Node.new(next_pos, current_node)

        queue.push(new_node)
        end
      end
    end
  end

  private

  def on_board?(pos)
    x, y = pos
    x.between?(0,7) && y.between?(0,7)
  end

  def each_valid_move(pos)
    start_x, start_y = pos
    MOVES.each do |move_x, move_y|
      end_x = start_x + move_x
      end_y = start_y + move_y
      next_pos = [end_x, end_y]
      yield next_pos if on_board?(next_pos)
    end
  end

  def reconstruct_path(end_node)
    path = []
    current_node = end_node

    while current_node
      path.unshift(current_node.position)
      current_node = current_node.parent
    end
    path
  end
end

solver = Knight.new

puts "Let's find the shortest path for a knight on a chessboard!"
puts "-" * 50

# Test Case 1
start1 = [0, 0]
finish1 = [1, 2]
path1 = solver.knight_moves(start1, finish1)
puts "You made it in #{path1.length - 1} moves! Here's your path from #{start1} to #{finish1}:"
path1.each { |p| p p }
puts "-" * 50

# Test Case 2
start2 = [0, 0]
finish2 = [3, 3]
path2 = solver.knight_moves(start2, finish2)
puts "You made it in #{path2.length - 1} moves! Here's your path from #{start2} to #{finish2}:"
path2.each { |p| p p }
puts "-" * 50

# Test Case 3
start3 = [3, 3]
finish3 = [0, 0]
path3 = solver.knight_moves(start3, finish3)
puts "You made it in #{path3.length - 1} moves! Here's your path from #{start3} to #{finish3}:"
path3.each { |p| p p }
puts "-" * 50

# Test Case 4
start4 = [0, 0]
finish4 = [7, 7]
path4 = solver.knight_moves(start4, finish4)
puts "You made it in #{path4.length - 1} moves! Here's your path from #{start4} to #{finish4}:"
path4.each { |p| p p }
puts "-" * 50
