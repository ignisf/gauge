class HomeController < ApplicationController
  def index
  end

  def ratings
    @talks = Talk.ordered_by_rating
    @ratings = Ratings.new
    @votes_count = TalkPreference.this_years.count
  end

  def export
    @talk_preferences = TalkPreference.this_years.eager_load(:selected_talks)
  end
end
