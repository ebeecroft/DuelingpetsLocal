class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :subsheet_id
      t.integer :bookgroup_id
      t.boolean :reviewed, default: false
      t.string :mp3
      t.string :ogg

      t.timestamps
    end
  end
end
