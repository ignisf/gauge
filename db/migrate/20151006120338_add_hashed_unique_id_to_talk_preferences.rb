class AddHashedUniqueIdToTalkPreferences < ActiveRecord::Migration[4.2]
  def change
    add_column :talk_preferences, :hashed_unique_id, :string
    add_index :talk_preferences, :hashed_unique_id
  end
end
