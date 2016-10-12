class ConflictsTable
  include ActiveModel::Model

  attr_accessor :talk_id, :other_talks_ids

  def other_talks_ids
    @other_talks_ids ||= []
  end

  def conflicts
    other_talks_ids.map do |right|
      {
       talk_id: right,
       number_of_conflicts: Conflicts.new(left: talk_id, right: right).conflicts
      }
    end
  end
end
