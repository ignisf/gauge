class TalkPreference < ActiveRecord::Base
  self.primary_key = :unique_id
  has_many :selected_talks
  serialize :talks, Array
end

class SelectedTalk < ApplicationRecord
  belongs_to :talk_preference
end

class RemoveTalksFromTalkPreferences < ActiveRecord::Migration[5.0]
  def up
    remove_column :talk_preferences, :talks, :text
  end

  def down
    add_column :talk_preferences, :talks, :text

    talk_preferences = TalkPreference.all

    talk_preferences.each do |preference|
      preference.talks = preference.selected_talks.pluck(:talk_id)
      preference.save!
    end
  end
end
