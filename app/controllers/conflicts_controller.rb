class ConflictsController < ApplicationController
  def index
    @talks = Talk.find(:all, from: :halfnarp_friendly).sort_by(&:title)
  end
end
