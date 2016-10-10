class ConflictsController < ApplicationController
  def index
    @talks = Talk.ordered_by_rating
  end

  def show
  end

  def pivot
    @talks = Talk.ordered_by_id
    @conflict_coefficients = ConflictCoefficient.all
  end
end
