module Drivable
  def drive
    puts "driving"
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive
