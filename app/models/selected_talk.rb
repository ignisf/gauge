class SelectedTalk < ApplicationRecord
  belongs_to :talk_preference

  def talk
    Talk.find talk_id, from: :halfnarp_friendly
  end
end
