class TalkPreference < ActiveRecord::Base
  self.primary_key = :unique_id

  serialize :talks, Array

  before_create :assign_new_unique_id

  private

  def assign_new_unique_id
    self.unique_id = SecureRandom.uuid
    self.hashed_unique_id = Digest::SHA1.hexdigest(self.unique_id)
  end
end
