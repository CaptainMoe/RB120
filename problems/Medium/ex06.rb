class GuessingGame
  def initialize(first, last)
    @trials = Math.log2(last - first).to_i + 1
    @range = Array(first..last)
    @target = @range.sample
  end

  def play
    loop do
      number_of_guesses_left
      take_a_guess
      evaluate_guess
      break if @number_guessed == @target || @trials == 0
      retry_message(@number_guessed)
    end
  end

  private

  def number_of_guesses_left
    puts "You have #{@trials} remaining."
  end

  def take_a_guess
    @number_guessed = nil
    loop do
      puts "Enter a number between #{@range[0]} and #{@range[-1]}"
      @number_guessed = gets.chomp.to_i
      break if @range.include?(@number_guessed)
      puts "Invalid guess. Enter a number between #{@range[0]} and #{@range[-1]}"
    end
    @trials -= 1
  end

  def evaluate_guess
    if @number_guessed == @target
      puts "That is the number!"
      puts "You won!"
    elsif @trials == 0
      puts "You have no more guesses."
      puts "You lost!"
    end
  end

  def retry_message(num)
    puts "Your guess is too high." if @target < num
    puts "Your guess is too low." if @target > num
    puts ""
  end
end

game = GuessingGame.new(501, 1500)
game.play
