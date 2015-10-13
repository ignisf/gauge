class HomeController < ApplicationController
  def index
  end

  def ratings
    @talks = Talk.ordered_by_rating
    @ratings = Ratings.new
  end

  def export
    @talks = Talk.all
    @talk_preferences = TalkPreference.all
  end
end
