class Person
  def initialize(name)
    @name = name
  end

  def name
    name = @name.clone
    name
  end
end

person1 = Person.new('James')
person1.name.reverse!
puts person1.name
