class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.text :description
      t.integer :forumtype_id
      t.integer :memberprivilege_id
      t.string :banner
      t.string :mp3
      t.string :ogg
      t.datetime :created_on
      t.integer :user_id
      t.boolean :music_on, default: false

      t.timestamps
    end
  end
end
