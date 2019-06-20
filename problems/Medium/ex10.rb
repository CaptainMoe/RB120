require 'pry'

# Include Card and Deck classes from the last two exercises.

class Card
  include Comparable
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    if suit == other.suit
      card_value <=> other.card_value
    elsif suit != other.suit
      suit_value <=> other.suit_value
    end
  end

  def card_value
    case rank
    when (2..10)
      @rank
    when 'Jack' then 11
    when 'Queen' then 12
    when 'King' then 13
    when 'Ace' then 14
    end
  end

  def suit_value
    case suit
    when 'Diamonds' then 1
    when 'Clubs' then 2
    when 'Hearts' then 3
    else 4
    end
  end

  def to_s
    "#{suit}: #{rank}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize()
    generate_deck
  end

  def draw
    generate_deck if @deck.empty?
    @deck.shift
  end

  private

  def generate_deck
    @deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        @deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end
end

class PokerHand
  def initialize(cards)
    @card_freq = Hash.new(0)
    @hand = cards

    cards.each do |card|
      @card_freq[card.card_value] += 1
    end
  end

  def print
    puts @hand

  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    royal_hand = ['Ace', 'King', 'Queen', 'Jack', 10]
    royal_rank = royal_hand.all? do |card|
      @hand.any? do |card1|
        card == card1.rank
      end
    end
    royal_rank && flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    @card_freq.values.sort == [1, 4]
  end

  def full_house?
    @card_freq.values.sort == [2, 3]
  end

  def flush?
    @hand.all? do |card|
      card.suit == @hand[0].suit
    end
  end

  def straight?
    card_ranks = find_all_card_ranks
    ordered_rank = []
    lowest_rank = card_ranks[0]
    5.times do |n|
      lowest_rank += 1 unless n == 0
      ordered_rank << lowest_rank
    end
    ordered_rank == card_ranks
  end

  def three_of_a_kind?
    @card_freq.values.sort == [1, 1, 3]
  end

  def two_pair?
    @card_freq.values.sort == [1, 2, 2]
  end

  def pair?
    @card_freq.values.sort == [1, 1, 1, 2]
  end

  def find_all_card_ranks
    card_rank = []
    @hand.each do |card|
      card_rank << card.card_value
    end
    card_rank.sort
  end
end

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])

puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])

puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
