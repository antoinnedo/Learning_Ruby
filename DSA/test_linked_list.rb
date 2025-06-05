require 'minitest/autorun'
require_relative 'linked_list'

class TestLinkedList < Minitest::Test
  def setup
    @list = LinkedList.new
  end

  # Test initialize
  def test_initial_state
    assert_nil @list.head
    assert_nil @list.tail
    assert_equal 0, @list.size
  end

  # Test append
  def test_append_to_empty_list
    @list.append(10)
    assert_equal 10, @list.head.value
    assert_equal 10, @list.tail.value
    assert_equal 1, @list.size
  end

  def test_append_multiple_items
    @list.append(10)
    @list.append(20)
    @list.append(30)
    assert_equal 10, @list.head.value
    assert_equal 30, @list.tail.value
    assert_equal 3, @list.size
  end

  # Test prepend
  def test_prepend_to_empty_list
    @list.prepend(10)
    assert_equal 10, @list.head.value
    assert_equal 10, @list.tail.value
    assert_equal 1, @list.size
  end

  def test_prepend_multiple_items
    @list.prepend(10)
    @list.prepend(20)
    @list.prepend(30)
    assert_equal 30, @list.head.value
    assert_equal 10, @list.tail.value
    assert_equal 3, @list.size
  end

  # Test at
  def test_at_with_empty_list
    assert_nil @list.at(0)
  end

  def test_at_with_valid_index
    @list.append(10)
    @list.append(20)
    @list.append(30)
    assert_equal 10, @list.at(0)
    assert_equal 20, @list.at(1)
    assert_equal 30, @list.at(2)
  end

  def test_at_with_invalid_index
    @list.append(10)
    assert_nil @list.at(1)
    assert_nil @list.at(-1)
  end

  # Test pop
  def test_pop_empty_list
    assert_nil @list.pop
    assert_equal 0, @list.size
  end

  def test_pop_single_item
    @list.append(10)
    assert_equal 10, @list.pop
    assert_nil @list.head
    assert_nil @list.tail
    assert_equal 0, @list.size
  end

  def test_pop_multiple_items
    @list.append(10)
    @list.append(20)
    @list.append(30)
    assert_equal 30, @list.pop
    assert_equal 20, @list.tail.value
    assert_equal 2, @list.size
  end

  # Test contains?
  def test_contains_empty_list
    refute @list.contains?(10)
  end

  def test_contains_existing_value
    @list.append(10)
    @list.append(20)
    assert @list.contains?(10)
    assert @list.contains?(20)
  end

  def test_contains_non_existing_value
    @list.append(10)
    refute @list.contains?(20)
  end

  # Test find
  def test_find_empty_list
    assert_nil @list.find(10)
  end

  def test_find_existing_value
    @list.append(10)
    @list.append(20)
    assert_equal 10, @list.find(10)
    assert_equal 20, @list.find(20)
  end

  def test_find_non_existing_value
    @list.append(10)
    assert_nil @list.find(20)
  end

  # Test to_s
  def test_to_s_empty_list
    assert_equal 'List is empty', @list.to_s
  end

  def test_to_s_single_item
    @list.append(10)
    assert_equal '( 10 )', @list.to_s
  end

  def test_to_s_multiple_items
    @list.append(10)
    @list.append(20)
    @list.append(30)
    expected = "( 10 ) -> ( 20 ) -> ( 30 )"
    assert_equal expected, @list.to_s
  end
end
