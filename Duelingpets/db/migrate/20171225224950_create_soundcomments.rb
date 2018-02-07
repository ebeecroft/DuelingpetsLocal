class CreateSoundcomments < ActiveRecord::Migration
  def change
    create_table :soundcomments do |t|
      t.text :message
      t.boolean :critique, default: false
      t.datetime :created_on
      t.integer :sound_id
      t.integer :user_id

      t.timestamps
    end
  end
end
