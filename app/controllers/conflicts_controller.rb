class ConflictsController < ApplicationController
  def index
    @talks = Talk.ordered_by_rating
  end
end
