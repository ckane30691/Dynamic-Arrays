# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(capacity)
    @capacity = capacity
    @store = Array.new(capacity)
  end

  # O(1)
  def [](index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  protected
  attr_accessor :store
end
