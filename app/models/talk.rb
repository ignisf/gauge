class Talk < ActiveResource::Base
  self.site = "https://cfp.openfest.org/api/conferences/2"
  self.element_name = "event"

  def self.ordered_by_rating
    ratings = Ratings.new
    all.sort { |left, right| ratings[right.id] <=> ratings[left.id] }
  end
end
