class ConflictsSummariesController < ApplicationController
  def show
    @conflicts_summary = ConflictsSummary.new conflicts_summary_params
  end

  private

  def conflicts_summary_params
    params.require(:conflicts_summary).permit(talk_ids: [])
  end
end
