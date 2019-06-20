
class CircularQueue
  attr_reader :array, :newest_element_index

  def initialize(size)
    @array = Array.new(size)
    @newest_element_index
  end

  def enqueue(element)
    if @newest_element_index.nil?
      @newest_element_index = 0
      current_index = @newest_element_index
    else
      @newest_element_index += 1
      current_index = @newest_element_index % array.size
    end
    @array[current_index] = element
  end

  def dequeue
    if @newest_element_index.nil? || @array.all? { |element| element.nil?}
      return nil
    else
      current_index = @newest_element_index % @array.size
      oldest_index = find_oldest_index(current_index)
      loop do
        break unless @array[oldest_index].nil?
        oldest_index = find_oldest_index(oldest_index)
      end
    end
    deleted_element = @array[oldest_index]
    @array[oldest_index] = nil
    deleted_element
  end

  private

  def find_oldest_index(current_index)
    (current_index + 1) % @array.size
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
