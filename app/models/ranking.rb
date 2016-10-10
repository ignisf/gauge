RankingEntry = Struct.new :talk_id, :votes, :place

class Ranking
  include ActiveModel::Model

  attr_accessor :talk_ids

  def ranking
    @ranking ||= ranking_data.map do |talk_id, votes, place|
      RankingEntry.new talk_id, votes, place
    end
  end

  def [](talk_id)
    ranking[talk_id]
  end

  def talk_ids
    @talk_ids ||= []
  end

  private

  def ranking_data
    vote_data.sort_by { |_, votes| -votes }
             .group_by { |_, votes| votes }
             .each_with_index.map do |votes, placement|
               votes.last.map {|talk_vote_data| talk_vote_data << placement + 1 }
             end.flatten(1)
  end

  def vote_data
    blank_vote_data.merge(database_vote_data)
  end

  def blank_vote_data
    talk_ids.map do |talk_id|
      [talk_id, 0]
    end.to_h
  end

  def database_vote_data
    SelectedTalk.group(:talk_id).where(talk_id: @talk_ids).count
  end
end
