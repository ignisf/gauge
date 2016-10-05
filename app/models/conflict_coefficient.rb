class ConflictCoefficient
  attr_reader :left, :right

  def self.all
    Talk.find(:all, from: :halfnarp_friendly).map(&:id).combination(2).map do |talks|
      ConflictCoefficient.new talks.first, talks.last
    end
  end

  def self.all_as_hash
    conflicts_hash = {}

    all.each do |coefficient|
      conflicts_hash[coefficient.left] = {} unless conflicts_hash[coefficient.left]
      conflicts_hash[coefficient.left][coefficient.right] = coefficient.per_cent
    end

    conflicts_hash
  end

  def conflicts
    @conflicts ||= talk_preferences.select do |talk_preference|
      talk_preference.include_all? [@left, @right]
    end.count
  end

  def total_votes
    talk_preferences.count
  end

  def initialize(left, right)
    @left, @right = left, right
  end

  def per_cent
    Rational(100 * conflicts, total_votes).to_f
  end

  private

  def talk_preferences
    @talk_preferences ||= TalkPreference.this_years
  end
end
