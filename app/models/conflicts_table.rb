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
       number_of_conflicts: conflicts_hash[right] || 0
      }
    end
  end

  private

  def conflicts_hash
    @conflicts_hash ||= Conflicts.where(left: talk_id, right: other_talks_ids).map do |conflicts|
      [conflicts.right, conflicts.conflicts]
    end.to_h
  end
end
