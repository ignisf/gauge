class Ratings
  @ratings = Hash.new(0)

  def initialize
    ratings = TalkPreference.all.pluck(:talks).reduce(Hash.new(0)) do |result, talks|
      talks.map(&:to_i).each { |talk| result[talk] += 1 }
      result
    end.to_h

    @ratings = Hash.new(0).merge!(ratings)
  end

  def [](id)
    @ratings[id]
  end
end
