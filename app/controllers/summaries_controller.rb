class SummariesController < ApplicationController
  def show
    @summary = Summary.new summary_params
  end

  private

  def summary_params
    params.require(:summary).permit(talk_ids: [])
  end
end
