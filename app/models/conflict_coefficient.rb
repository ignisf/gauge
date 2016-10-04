class ConflictCoefficient
  attr_reader :left, :right, :conflicts

  def self.all
    talk_combinations = Talk.find(:all, from: :halfnarp_friendly).map(&:id).combination(2)
    talk_preferences = TalkPreference.all
    talk_preferences_count = TalkPreference.count

    talk_combinations.map do |talks|
      conflicts = talk_preferences.select do |talk_preference|
        talk_preference.include_all? talks
      end.count

      ConflictCoefficient.new talks.first, talks.last, conflicts, talk_preferences_count
    end
  end

  def initialize(left, right, conflicts, total_votes)
    @left, @right, @conflicts, @total_votes = left, right, conflicts, total_votes
  end

  def per_cent
    Rational(100 * @conflicts, @total_votes).to_f
  end
end
