class Summary
  include ActiveModel::Model

  attr_accessor :talk_ids

  def number_of_ballots
    @number_of_ballots ||= TalkPreference.joins(:selected_talks)
                                         .where(selected_talks: {talk_id: @talk_ids})
                                         .uniq.count
  end

  def ranking
    @ranking ||= Ranking.new(talk_ids: talk_ids).ranking
  end
end
