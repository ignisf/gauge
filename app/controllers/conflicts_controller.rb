class ConflictsController < ApplicationController
  def show
    @conflicts_table = ConflictsTable.new conflicts_table_params
  end

  private

  def conflicts_table_params
    params.require(:conflicts_table).permit(:talk_id, other_talks_ids: [])
  end
end
