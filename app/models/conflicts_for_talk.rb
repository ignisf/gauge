class ConflictsForTalk < ApplicationRecord
  def self.most
    order(conflicts: :desc).first
  end

  def self.least
    order(conflicts: :asc).first
  end
end
