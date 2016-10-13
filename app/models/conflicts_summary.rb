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
       conflicts: conflicts_table[talk_id]
      }
    end
  end

  private

  def conflicts_table
    @conflicts_table ||= blank_conflicts_table.merge(database_conflicts_table)
  end

  def database_conflicts_table
    Conflicts.where(left: talk_ids, right: talk_ids).group_by(&:left).map do |left, conflicts|
      conflicts_row = blank_conflicts_row(talk_ids_without(left))
      conflicts_row.merge! conflicts.map { |right_conflicts| [right_conflicts.right, right_conflicts.conflicts] }.to_h
      [left, conflicts_row]
    end.to_h
  end

  def talk_ids_without(talk_id)
    talk_ids.reject { |id| id == talk_id }
  end

  def blank_conflicts_row(other_talk_ids)
    other_talk_ids.map { |talk_id| [talk_id, 0] }.to_h
  end

  def blank_conflicts_table
    talk_ids.map { |talk_id| [talk_id, blank_conflicts_row(talk_ids_without(talk_id))] }.to_h
  end
end
