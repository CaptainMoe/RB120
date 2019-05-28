require 'pry'

class WheeledVehicle
  attr_accessor :fuel, :distance

  def initialize
    binding.pry
    fuel = 10
    distance = 10
  end

  def fueleffecient
    distance
  end
end

my_car = WheeledVehicle.new
my_car.distance