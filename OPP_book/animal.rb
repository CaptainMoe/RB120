class Parent
  def say_hi
    p "Hi from Parent."
  end
end

class Child < Parent
  def say_hi
    p "Hi from Child."
  end
end

parent = Parent.new
child = Child.new

parent.say_hi
child.say_hi