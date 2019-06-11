
class Participant
  attr_accessor :hand

  def initialize
    self.hand = []
  end

  def hit(deck)
    @hand << deck.remove_top_card
  end

  def bust?
    hand_total > 21
  end

  def hand_total
    sum = 0
    hand.each do |card|
      sum += value_of(card)
    end
    num_aces = count_aces(hand)

    num_aces.times do
      sum -= 10 if sum > 21
    end
    sum
  end

  def change_card_at(index, suit)
    hand[index] = Card.new(suit, 'Ace')
  end

  private

  def count_aces(hand)
    hand.count do |card|
      card.value == 'Ace'
    end
  end

  def value_of(card)
    case card.value
    when 'Ace'
      11
    when 'King'
      10
    when 'Queen'
      10
    when 'Jack'
      10
    else
      card.value
    end
  end
end

class Player < Participant
  def display_hand
    hand_output = []
    hand.each do |card|
      hand_output << "#{card.value}:#{card.suit}"
    end
    puts "Player's hand=> [#{hand_output.join(', ')}]"
    puts "Your hand's total: #{hand_total}"
  end
end

class Dealer < Participant
  def display_hand
    hand_output = []
    first_card = hand[0]
    unkown_cards = hand.size - 1

    hand_output << "#{first_card.value}:#{first_card.suit}"
    unkown_cards.times { hand_output << "unkown_card" }

    puts "Dealer's hand=> [#{hand_output.join(', ')}]"
  end
end

class Deck
  SUITS = ['Diamonds', 'Clubs', 'Hearts', 'Spades']
  FACE_CARDS = ['Ace', 'King', 'Queen', 'Jack']

  def initialize
    @cards = generate_deck
  end

  def deal
    shuffle
    hand = []
    2.times do
      hand << @cards.shift
    end
    hand
  end

  def shuffle
    @cards = @cards.shuffle
  end

  def remove_top_card
    @cards.shift
  end

  private

  def generate_deck
    deck = []
    SUITS.each do |suit|
      (2..10).each do |value|
        deck << Card.new(suit, value)
      end
      FACE_CARDS.each { |face_card| deck << Card.new(suit, face_card) }
    end
    deck
  end
end

class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
  end

  def start
    welcom_message
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end

  private

  def deal_cards
    system('clear') || system('cls')

    player.hand = deck.deal
    dealer.hand = deck.deal
  end

  def show_initial_cards
    player.display_hand
    dealer.display_hand
  end

  def player_turn
    puts "------Player's turn-------"
    loop do
      puts "Do you want to (h)it or (s)tay"
      answer = player_hit_or_stay
      case answer
      when 'h'
        player.hit(deck)
        puts "=>You hit"
      when 's'
        puts "=>You stay"
        break
      end

      player.display_hand
      break if player.bust?
    end
  end

  def dealer_turn
    return if player.bust?
    puts "-------Dealer's turn-------"
    loop do
      if dealer.hand_total < 17
        puts "=>Dealer hits"
        dealer.hit(deck)
        dealer.display_hand
      else
        puts "=>Dealer stays"
        break
      end

      break if dealer.bust?
    end
  end

  def player_hit_or_stay
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      puts "Wrong input, Enter h or s!"
    end
    answer
  end

  def show_result
    puts "-------results-------"
    display_total_hand_values
    if player.bust?
      puts "=>You busted"
      puts "=>Dealer wins!"
    elsif dealer.bust?
      puts "=>Dealer busted!"
      puts "=>You win!"
    else
      case compare_participant_hands
      when 1 then puts "=>You won!"
      when -1 then puts "=>Dealer won!"
      when 0 then puts "It is a tie!"
      end
    end
  end

  def compare_participant_hands
    player.hand_total <=> dealer.hand_total
  end

  def display_total_hand_values
    puts "Your total:     #{player.hand_total}"
    puts "Dealer's total: #{dealer.hand_total}"
  end

  def welcom_message
    puts "Welcom to TicTacToe!"

    @player = Player.new
    @dealer = Dealer.new
  end
end

Game.new.start
