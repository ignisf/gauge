class TalkPreference < ActiveRecord::Base
  self.primary_key = :unique_id
  serialize :talks, Array
end

class SelectedTalk < ApplicationRecord
end

class CreateSelectedTalks < ActiveRecord::Migration[5.0]
  def up
    create_table :selected_talks do |t|
      t.references :talk, foreign_key: false
      t.string :talk_preference_id, foreign_key: true
    end

    talk_preferences = TalkPreference.all

    talk_preferences.each do |preference|
      preference.talks.each do |talk|
        SelectedTalk.create! talk_id: talk, talk_preference_id: preference.unique_id
      end
    end
  end

  def down
    drop_table :selected_talks
  end
end
