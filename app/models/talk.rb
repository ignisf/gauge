class Talk < ActiveResource::Base
  has_many :selections, class_name: 'SelectedTalk'

  self.site = "https://cfp.openfest.org/api/conferences/3"
  self.element_name = "event"

  def self.ordered_by_rating
    ratings = Ratings.new
    find(:all, from: :halfnarp_friendly).sort { |left, right| ratings[right.id] <=> ratings[left.id] }
  end
end
