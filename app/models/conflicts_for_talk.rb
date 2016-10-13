class ConflictsForTalk < ApplicationRecord
  def self.most
    first
  end

  def self.least
    last
  end
end
