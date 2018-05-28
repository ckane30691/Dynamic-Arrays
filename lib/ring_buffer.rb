require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @length = 0
    @capacity = capacity
    @start_idx = 0
  end

  # O(1)
  def [](index)
    validate!(index)
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    validate!(index)
    @store[(@start_idx + index) % @capacity] = val
    val
  end

  # O(1)
  def pop
    validate!(0)
    val = self[@length - 1]
    @length -= 1
    val
  end

  # O(1) ammortized
  def push(val)
    resize! if @capacity <= @length
    @length += 1
    self[@length - 1] = val
    val
  end

  # O(1)
  def shift
    validate!(0)
    val = @store[@start_idx]
    @start_idx = (@start_idx + 1) % @capacity
    @length -= 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @capacity <= @length
    @start_idx = (@start_idx - 1) % @capacity
    @store[@start_idx] = val
    @length += 1
    val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def validate!(index)
    raise "index out of bounds" if @length.zero? || !index.between?(0, @length - 1)
  end

  def resize!
    oldStore = @store
    @store = StaticArray.new(@capacity * 2)
    oldCapacity = @capacity
    @capacity *= 2
    @length.times do |idx|
      self[idx] = oldStore[(@start_idx + idx) % oldCapacity]
    end
  end
end
