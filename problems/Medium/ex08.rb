require 'pry'

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

deck = Deck.new

drawn = []
52.times { drawn << deck.draw }

drawn.count { |card| card.rank == 5 } == 4
drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }

binding.pry

drawn != drawn2 # Almost always.
