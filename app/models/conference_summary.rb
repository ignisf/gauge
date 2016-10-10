class ConferenceSummary
  def initialize(params = {})
    @talk_ids = params[:talk_ids]
  end

  def number_of_ballots
    TalkPreference.joins(:selected_talks)
                   .where(selected_talks: {
                                           talk_id: @talk_ids
                                          })
                   .uniq.count
  end

  def ratings

  end
end
