class CreateSoundvisits < ActiveRecord::Migration
  def change
    create_table :soundvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :sound_id

      t.timestamps
    end
  end
end
