
require 'pry'

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    self.score = 0
    self.move_history = []
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please choose #{Move::VALUES}"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
    end
    self.move = Move.new(choice)
    move_history << move.value
  end

  def set_name
    n = ""
    loop do
      puts "What is your name?"
      n = gets.chomp
      break unless n.empty?
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = Move.new(Move::VALUES.sample)
    move_history << move.value
  end

  def set_name
    self.name = ['R2D2', 'HAL', 'CHAPIE', 'ALLIE'].sample
  end
end

class Move
  WINNING = { 'rock' => ['scissors', 'lizard'],
              'paper' => ['rock', 'spock'],
              'scissors' => ['paper', 'lizard'],
              'lizard' => ['paper', 'spock'],
              'spock' => ['scissors', 'rock'] }

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING[value].include?(other_move.value)
  end

  def to_s
    @value
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcom to Rock, Paper, Scissors!"
  end

  def display_goodbay_message
    puts "Thanks for playing Rock, Paper, Scissors."
  end

  def display_winner_message
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    final_winner?
  end

  def display_move_history
    puts "#{human.name}'s moves: #{human.move_history}"
    puts "#{computer.name}'s moves: #{computer.move_history}"
  end

  def display_choice
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} computer chose #{computer.move}"
  end

  def display_winner
    display_choice

    if computer.move > human.move
      puts ">>>>#{@computer.name} won this turn."
    elsif human.move > computer.move
      puts ">>>>#{@human.name} won this turn."
    else
      puts "It is a tie"
    end
  end

  def winner?
    if computer.move > human.move
      computer
    elsif human.move > computer.move
      human
    end
  end

  def final_winner?
    puts "#{human.name} won the Game!" if human.score > computer.score
    puts "#{computer.name} won the Game!" if human.score < computer.score
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end
    return true if answer == 'y'
    false
  end

  def increment_score(player)
    player.score += 1 unless player.nil?
  end

  def final_score_reached?
    human.score >= 5 || computer.score >= 5
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      increment_score(winner?)
      display_winner
      break if final_score_reached? || (play_again? == false)
    end
    display_winner_message
    display_move_history
    display_goodbay_message
  end
end

RPSGame.new.play
