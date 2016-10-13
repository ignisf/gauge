class Summary
  include ActiveModel::Model

  attr_accessor :talk_ids

  def number_of_ballots
    @number_of_ballots ||= TalkPreference.joins(:selected_talks)
                                         .where(selected_talks: {talk_id: @talk_ids})
                                         .uniq.count
  end

  def most_conflicts
    Conflicts.where(left: talk_ids, right: talk_ids).most.conflicts
  end

  def least_conflicts
    if least_conflicts_for_single_talk == 0
      0
    else
      least_conflicts_between_two_talks
    end
  end

  def ranking
    @ranking ||= Ranking.new(talk_ids: talk_ids).ranking
  end

  private

  def least_conflicts_for_single_talk
    ConflictsForTalk.where(talk_id: talk_ids).least.conflicts
  end

  def least_conflicts_between_two_talks
    Conflicts.where(left: talk_ids, right: talk_ids).least.conflicts
  end
end
