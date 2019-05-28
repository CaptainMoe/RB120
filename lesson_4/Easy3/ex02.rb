class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    greet = Greeting.new
    greet.greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

puts Hello.hi