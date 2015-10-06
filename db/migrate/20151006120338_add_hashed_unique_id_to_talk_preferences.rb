class AddHashedUniqueIdToTalkPreferences < ActiveRecord::Migration
  def change
    add_column :talk_preferences, :hashed_unique_id, :string
    add_index :talk_preferences, :hashed_unique_id
  end
end
