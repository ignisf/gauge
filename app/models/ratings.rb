class Ratings
  def initialize
    @ratings = {}
  end

  def [](id)
    @ratings[id] ||= SelectedTalk.where(talk_id: id).count
  end
end
