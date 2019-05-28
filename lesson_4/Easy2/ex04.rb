class BeesWax
  attr_accessor :type
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{type} of Bees Wax"
  end
end

wax = BeesWax.new("beeswax")

puts wax.type = "bee"