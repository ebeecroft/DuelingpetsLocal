class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :name
      t.text :description
      t.string :mp3
      t.string :ogg
      t.datetime :created_on
      t.integer :user_id
      t.boolean :music_on, default: false

      t.timestamps
    end
  end
end
