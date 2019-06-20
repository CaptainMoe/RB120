require 'pry'

class Pet
  attr_reader :creature, :name

  def initialize(creature, name)
    @creature = creature
    @name = name
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_a_pet(pet)
    @pets << pet
  end

  def number_of_pets
    @pets.size
  end

  def print_pets
    @pets.each do |pet|
      puts "a #{pet.creature} named #{pet.name}"
    end
  end
end

class Shelter
  @@number_of_pets = 0

  attr_reader :unadopted_pets
  def initialize
    @owners = {}
    @unadopted_pets = []
  end

  def register_pet(creature, name)
    @@number_of_pets = unadopted_pets.size
    @unadopted_pets << Pet.new(creature, name)
    @unadopted_pets[@@number_of_pets]
  end

  def adopt(owner, pet)
    owner.add_a_pet(pet)
    @unadopted_pets.delete(pet)
    @owners[owner.name] ||= owner
  end

  def print_adoptions
    @owners.each do |name, owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.print_pets
    end
  end
end

shelter = Shelter.new
phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

butterscotch = shelter.register_pet('cat', 'Butterscotch')
shelter.adopt(phanson, butterscotch)

pudding      = shelter.register_pet('cat', 'Pudding')
shelter.adopt(phanson, pudding)

darwin       = shelter.register_pet('bearded dragon', 'Darwin')
shelter.adopt(phanson, darwin)

kennedy      = shelter.register_pet('dog', 'Kennedy')
shelter.adopt(bholmes, kennedy)

sweetie      = shelter.register_pet('parakeet', 'Sweetie Pie')
shelter.adopt(bholmes, sweetie)

molly        = shelter.register_pet('dog', 'Molly')
shelter.adopt(bholmes, molly)

chester      = shelter.register_pet('fish', 'Chester')
shelter.adopt(bholmes, chester)

shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The animal shelter has #{shelter.unadopted_pets.size} unadopted pets"
