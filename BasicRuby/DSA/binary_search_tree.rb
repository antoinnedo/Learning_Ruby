# Node represents a single node in the binary search tree.
# It includes Comparable to allow nodes to be compared based on their value.
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
  end

  # Compares this node's value with another node's value.
  def <=>(other)
    # Corrected from :data to :value
    @value <=> other.value
  end
end

# Tree represents the binary search tree itself.
# It can be initialized with an array, which it will sort and build into a
# balanced binary search tree.
class Tree
  attr_accessor :root

  def initialize(array)
    # Sort the array and remove duplicates to ensure a valid BST.
    processed_array = array.uniq.sort
    @root = build_tree(processed_array)
  end

  # Recursively builds a balanced binary search tree from a sorted array.
  # It works by repeatedly finding the middle element and making it the root
  # of the subtree, then recursively doing the same for the left and right halves.
  def build_tree(array)
    return nil if array.empty?

    mid_index = array.length / 2
    node = Node.new(array[mid_index])

    # Corrected implementation using array slicing for clarity.
    node.left_child = build_tree(array[0...mid_index])
    node.right_child = build_tree(array[mid_index + 1..-1])

    node
  end

  # Inserts a value into the tree.
  # It prevents duplicate values from being inserted.
  def insert(value, node = @root)
    # If the current node is nil, we've found the insertion point.
    return Node.new(value) if node.nil?
    # Do not insert if the value already exists.
    return node if node.value == value

    # Recur down the tree and assign the result to the correct child.
    if value < node.value
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end
    node
  end

  # Deletes a value from the tree.
  def delete(value, node = @root)
    return node if node.nil?

    if value < node.value
      node.left_child = delete(value, node.left_child)
    elsif value > node.value
      node.right_child = delete(value, node.right_child)
    else
      # Node with the value to be deleted is found.

      # Case 1: Node has 0 or 1 child.
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      # Case 2: Node has 2 children.
      # Find the inorder successor (smallest value in the right subtree).
      inorder_successor = find_min(node.right_child)
      # Replace the node's value with the successor's value.
      node.value = inorder_successor.value
      # Delete the inorder successor from the right subtree.
      node.right_child = delete(inorder_successor.value, node.right_child)
    end
    node
  end

  # Finds the node with the minimum value in a given subtree.
  def find_min(node)
    current = node
    # Use safe navigation operator `&.` in case node is nil
    current = current.left_child while current&.left_child
    current
  end

  # Finds a node with a given value in the tree.
  def find(value, node = @root)
    return nil if node.nil?
    return node if node.value == value

    # Corrected conditional logic.
    if value < node.value
      find(value, node.left_child)
    else
      find(value, node.right_child)
    end
  end

  # --- Traversal Methods ---

  # Breadth-First Search (BFS), also known as Level Order Traversal.
  # It visits nodes level by level, from left to right.
  # If a block is given, it yields each node to the block.
  # Otherwise, it returns an array of the values in level order.
  def level_order
    return [] if @root.nil?

    queue = [@root]
    result = []
    while queue.any?
      current = queue.shift
      if block_given?
        yield current
      else
        result << current.value
      end
      queue.push(current.left_child) if current.left_child
      queue.push(current.right_child) if current.right_child
    end
    result unless block_given?
  end

  alias bfs level_order

  # In-order Traversal (Left, Root, Right).
  # Visits nodes in ascending order.
  def inorder(node = @root, result = [], &block)
    return if node.nil?
    inorder(node.left_child, result, &block)
    block_given? ? yield(node) : result << node.value
    inorder(node.right_child, result, &block)
    result unless block_given?
  end

  # Pre-order Traversal (Root, Left, Right).
  # Useful for creating a copy of the tree.
  def preorder(node = @root, result = [], &block)
    return if node.nil?
    block_given? ? yield(node) : result << node.value
    preorder(node.left_child, result, &block)
    preorder(node.right_child, result, &block)
    result unless block_given?
  end

  # Post-order Traversal (Left, Right, Root).
  # Useful for deleting the tree.
  def postorder(node = @root, result = [], &block)
    return if node.nil?
    postorder(node.left_child, result, &block)
    postorder(node.right_child, result, &block)
    block_given? ? yield(node) : result << node.value
    result unless block_given?
  end

  alias dfs_preorder preorder
  alias dfs_inorder inorder
  alias dfs_postorder postorder

  # --- Utility Methods ---

  # Calculates the height of a given node.
  # Height is the number of edges in the longest path from the node to a leaf node.
  def height(node)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  # Calculates the depth of a given node.
  # Depth is the number of edges from the root to the node.
  def depth(node, current = @root, d = 0)
    return nil if node.nil? || current.nil?
    return d if node == current

    if node < current
      depth(node, current.left_child, d + 1)
    else
      depth(node, current.right_child, d + 1)
    end
  end

  # Checks if the tree is balanced.
  # A tree is balanced if the height difference between the left and right subtrees
  # of every node is no more than 1.
  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)

    return false if (left_height - right_height).abs > 1

    balanced?(node.left_child) && balanced?(node.right_child)
  end

  # Rebalances the tree by converting it to an array (via in-order traversal)
  # and then building a new, balanced tree from that array.
  def rebalance
    return if balanced?

    sorted_array = inorder
    @root = build_tree(sorted_array)
  end

  # Provides a simple visual representation of the tree structure.
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    # Corrected from :data to :value
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

# --- Driver Script ---
puts "--- Initializing Tree ---"
# Create a new tree from an array of random numbers
random_numbers = Array.new(15) { rand(1..100) }
tree = Tree.new(random_numbers)
tree.pretty_print
puts "Is the tree balanced? #{tree.balanced?}"

puts "\n--- Traversals of initial tree ---"
puts "BFS/Level Order: #{tree.bfs}"
puts "DFS Pre-order:   #{tree.dfs_preorder}"
puts "DFS In-order:    #{tree.dfs_inorder}"
puts "DFS Post-order:  #{tree.dfs_postorder}"

puts "\n--- Unbalancing the tree ---"
puts "Inserting 110, 120, 130..."
tree.insert(110)
tree.insert(120)
tree.insert(130)
tree.pretty_print
puts "Is the tree balanced? #{tree.balanced?}"


puts "\n--- Rebalancing the tree ---"
tree.rebalance
tree.pretty_print
puts "Is the tree balanced? #{tree.balanced?}"

puts "\n--- Traversals of rebalanced tree ---"
puts "BFS/Level Order: #{tree.bfs}"
puts "DFS Pre-order:   #{tree.dfs_preorder}"
puts "DFS In-order:    #{tree.dfs_inorder}"
puts "DFS Post-order:  #{tree.dfs_postorder}"
