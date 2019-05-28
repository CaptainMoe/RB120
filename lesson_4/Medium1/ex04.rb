
class Greeting

  def greet(str)
    str
  end
end

class Hello < Greeting

  def hi
    "Hello"
  end
end

class Goodbye < Greeting

  def bye
    greet("bye")
  end
end