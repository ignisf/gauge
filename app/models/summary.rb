class Summary
  def initialize(params = {})
    @talk_id, @other_talk_ids = params[:talk_id], params[:other_talk_ids]
    @votes_count = SelectedTalk.where(talk_id: @talk_id).count
    @all_votes_count = TalkPreference.joins(:selected_talks).where(selected_talks: {talk_id: @other_talk_ids << @talk_id}).uniq.count
  end

  def summary
    {
     talk_id: @talk_id,
     votes: @votes_count,
     all_votes: @all_votes_count,
     per_cent: Rational(@votes_count, @all_votes_count).to_f,
     conflicts: conflicts
    }
  end

  def conflicts
    @other_talk_ids.map do |right|
      [right, ConflictCoefficient.new(@talk_id, right).conflicts]
    end.to_h
  end
end
