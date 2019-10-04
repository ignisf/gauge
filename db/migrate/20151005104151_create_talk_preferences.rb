class CreateTalkPreferences < ActiveRecord::Migration[4.2]
  def change
    create_table :talk_preferences, id: false do |t|
      t.string :unique_id, null: false
      t.string :ip_address
      t.text :talks

      t.timestamps null: false
    end

    add_index :talk_preferences, :unique_id, unique: true
  end
end
