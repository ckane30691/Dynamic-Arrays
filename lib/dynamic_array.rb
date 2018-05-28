require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @length = 0
    @capacity = capacity
  end

  # O(1)
  def [](index)
    validate!(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    validate!(index)
    @length += 1
    @store[index] = value
  end

  # O(1)
  def pop
    validate!(0)
    @length -= 1
    val = @store[@length]
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @capacity <= @length
    @store[@length] = val
    @length += 1
    val
  end

  # O(n): has to shift over all the elements.
  def shift
    validate!(0)
    oldStore = @store
    val = oldStore[0]
    @store = StaticArray.new(@capacity)
    (1...@length).each do |idx|
      @store[idx - 1] = oldStore[idx]
    end
    @length -= 1
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @capacity <= @length
    oldStore = @store
    @store = StaticArray.new(@capacity)
    @store[0] = val
    (1..@length).each do |idx|
      @store[idx] = oldStore[idx - 1]
    end
    @length += 1
    val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def validate!(index)
    raise "index out of bounds" if @length.zero? || !index.between?(0, @length - 1)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    oldStore = @store
    @store = StaticArray.new(@capacity * 2)
    @capacity *= 2
    @length.times do |idx|
      @store[idx] = oldStore[idx]
    end
  end
end
