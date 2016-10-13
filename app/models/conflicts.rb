class Conflicts < ApplicationRecord
  def self.most
    order(conflicts: :desc).try(:first)
  end

  def self.least
    order(conflicts: :asc).try(:first)
  end
end
