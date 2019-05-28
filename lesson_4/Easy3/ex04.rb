class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat."
  end
end

cat1 = Cat.new("Tabby")

puts cat1.to_s