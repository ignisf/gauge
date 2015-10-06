class TalkPreference < ActiveRecord::Base
  self.primary_key = :unique_id
end

class PopulateHashedUniqueIdInTalkPreferences < ActiveRecord::Migration
  def up
    TalkPreference.all.each do |talk_preference|
      talk_preference.hashed_unique_id = Digest::SHA1.hexdigest(talk_preference.unique_id)
      talk_preference.save!
    end
  end

  def down
    TalkPreference.all.each do |talk_preference|
      talk_preference.hashed_unique_id = nil
      talk_preference.save!
    end
  end
end
