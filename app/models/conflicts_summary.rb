class ConflictsSummary
  include ActiveModel::Model

  attr_accessor :talk_ids

  def talk_ids
    @talk_ids ||= []
  end

  def conflicts
    talk_ids.map do |talk_id|
      {
       talk_id: talk_id,
       conflicts: ConflictsTable.new(talk_id: talk_id, other_talks_ids: talk_ids.reject { |id| id == talk_id }).conflicts
      }
    end
  end
end
