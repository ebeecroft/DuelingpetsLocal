class CreateUserinfos < ActiveRecord::Migration
  def change
    create_table :userinfos do |t|
      t.string :avatar
      t.string :miniavatar
      t.text :info
      t.string :browser
      t.string :vbrowser
      t.string :mp3
      t.string :ogg
      t.integer :user_id
      t.boolean :music_on, default: false
      t.integer :colorscheme_id

      t.timestamps
    end
  end
end
