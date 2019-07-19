require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def [](key)
    @squares[key].marker
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def values_at(line)
    line.map do |square|
      @squares[square].marker
    end
  end

  def winning_marker
    WINNING_LINES.each do |line|
      markers_on_line = values_at(line)
      if three_identical_marker?(markers_on_line)
        return markers_on_line.sample
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts"     |     |"
    puts"  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts"     |     |"
    puts"-----------------"
    puts"     |     |"
    puts"  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts"     |     |"
    puts"-----------------"
    puts"     |     |"
    puts"  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts"     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_marker?(line_markers)
    return false if line_markers.include?(Square::INITIAL_MARKER)
    line_markers.uniq.size == 1
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    !unmarked?
  end

  def to_s
    marker
  end
end

class Player
  attr_reader :marker, :score, :name
  def initialize(marker)
    set_name
    @marker = marker
    @score = 0
  end

  def won
    @score += 1
  end
end

class Person < Player
  def set_name
    name = nil
    puts "What is your name?"

    loop do
      # binding.pry
      name = gets.chomp
      break unless name.empty? || name.squeeze == " "
      puts "Wrong input, Please enter your name."
    end

    @name = name
  end
end

class Computer < Player
  def set_name
    fictional_computers = ["Cerebro", "C-3PO", "Gideon",
                           "JARVIS", "The Matrix"]
    @name = fictional_computers.sample
  end
end

class TTTGame
  attr_reader :board, :human, :computer

  def initialize
    markers = human_and_computer_marker
    @board = Board.new
    @human = Person.new(markers[:human_marker])
    @computer = Computer.new(markers[:computer_marker])
    @current_marker = markers[:human_marker]
  end

  def play
    display_welcom_message
    loop do
      display_board
      loop do
        current_player_moves
        break if board.someone_won? || board.full?

        clear_screen_and_display_board
      end
      display_result

      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def display_welcom_message
    puts "Welcom to Tic Tac Toe"
  end

  def display_goodbye_message
    puts "Tnanks for playing Tic Tac Toe."
  end

  def pick_a_marker
    player_marker = nil
    loop do
      player_marker = gets.chomp
      break if player_marker.size == 1 &&
               !Array('0'..'9').include?(player_marker)
      puts "Sorry, wrong input, pick just 1 letter."
    end
    player_marker
  end

  def human_and_computer_marker
    puts "What is your marker?"
    human_marker = pick_a_marker.upcase
    puts "Pick a marker for computer:"

    # Make sure the computer marker is not the same as human marker.
    computer_marker = nil
    loop do
      computer_marker = pick_a_marker.upcase
      break unless computer_marker == human_marker
      puts "You can't choose the same marker, Please select another marker."
    end
    { computer_marker: computer_marker, human_marker: human_marker }
  end

  def joinor(delimeter)
    key_options = board.unmarked_keys
    if key_options.size > 1
      key_options[0...-1].join(', ') + " #{delimeter} " + key_options.last.to_s
    else
      key_options.first.to_s
    end
  end

  def human_moves
    puts "choose a square between #{joinor('or')}: "
    square = nil
    loop do
      square = gets.chomp
      break if board.unmarked_keys.include?(square.to_i) &&
               square.to_i == square.to_f
      puts "Sorry, that is not a valid choice. Try Again."
    end

    board[square.to_i] = human.marker
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  # Find squares that can make player lose
  def winning_squares_for(player)
    threatful_lines = Board::WINNING_LINES.select do |line|
      values = board.values_at(line)
      values.count(player.marker) == 2 && values.include?(" ")
    end
    threatful_lines.flatten.uniq.select do |square|
      board[square] != player.marker
    end
  end

  # Find the square to defend against human palyer
  # Find the squares to win against human player
  def computer_square_options
    defense = winning_squares_for(human)
    offense = winning_squares_for(computer)
    if !offense.empty?
      offense
    elsif !defense.empty?
      defense
    else
      board.unmarked_keys
    end
  end

  def computer_moves
    square = computer_square_options.sample
    board[square] = computer.marker
  end

  def display_result
    winning_message = nil
    case board.winning_marker
    when human.marker
      human.won
      winning_message = "#{human.name} won!"
    when computer.marker
      computer.won
      winning_message = "#{computer.name} won!"
    else
      winning_message = "It is a tie!"
    end
    clear_screen_and_display_board
    puts winning_message
  end

  def play_again?
    puts "Do you want to play again?(yes, no)"
    ans = ""
    loop do
      #binding.pry
      ans = gets.chomp
      break if ['yes', 'no'].include?(ans.downcase)
      puts "Wrong input! please put yes or no"
    end
    ans.downcase == 'yes'
  end

  def reset
    clear
    board.reset
    @current_marker = human.marker
    puts "Let play again!"
    puts ""
  end

  def clear
    system 'clear'
  end

  def display_board
    puts "Your opponent is '#{computer.name}'"
    puts "#{human.name}'s score: #{human.score}, " \
         "#{computer.name}'s score: #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end
end

game = TTTGame.new
game.play
