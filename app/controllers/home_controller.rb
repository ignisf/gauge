class HomeController < ApplicationController
  def index
  end

  def ratings
    @talks = Talk.ordered_by_rating
    @ratings = Ratings.new
  end
end
