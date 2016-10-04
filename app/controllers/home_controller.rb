class HomeController < ApplicationController
  def index
  end

  def ratings
    @talks = Talk.ordered_by_rating
    @ratings = Ratings.new
    @votes_count = TalkPreference.count
  end

  def export
    @talks = Talk.find(:all, from: :halfnarp_friendly)
    @talk_preferences = TalkPreference.all
  end

  def conflicts
    @conflict_coefficients = ConflictCoefficient.all
  end
end
