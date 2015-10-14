class TalkPreference < ActiveRecord::Base
  self.primary_key = :unique_id

  serialize :talks, Array

  before_create :assign_new_unique_id

  def include?(id)
    talks.include? id.to_s
  end

  def include_all?(ids)
    ids.all? { |id| include? id }
  end

  private

  def assign_new_unique_id
    self.unique_id = SecureRandom.uuid
    self.hashed_unique_id = Digest::SHA1.hexdigest(self.unique_id)
  end
end
