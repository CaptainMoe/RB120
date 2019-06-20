module Walkable
  def walk
    puts "#{self} #{gait} forward"
  end
end

class Person
  include Walkable

  attr_reader :name, :title

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "strolls"
  end
end

class Noble
  include Walkable

  attr_reader :name, :title

  def initialize(name, title)
    @title = title
    @name = name
  end

  def to_s
    "#{title} #{name}"
  end

  private

  def gait
    "strut"
  end
end


mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"


byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"
